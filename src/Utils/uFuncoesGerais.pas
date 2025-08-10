unit uFuncoesGerais;

interface

uses
  Winapi.Windows, Winapi.Messages,  FireDAC.Comp.Client, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, System.JSON, System.Classes, System.SysUtils , Dialogs,
  System.RTTI, Data.DB, Xml.XMLIntf, Xml.XMLDoc, Variants;

   procedure TrocaTabPorEnter(var Key: Char);
   function SomenteNumeros(const Texto: string): string;
   procedure CarregarJSONNoMemTable(const AJSONArray: TJSONArray; const AMemTable: TFDAdaptedDataset);
   procedure CarregarXMLNoMemTable(const  AXmlDoc: string; const AMemTable: TFDMemTable);
   function NodeTextSafe(const N: IXMLNode): string;
   function IsLeafElement(const N: IXMLNode): Boolean;
   function IsElement(const N: IXMLNode): Boolean;
   function TryDetectList(const Root: IXMLNode; out Container: IXMLNode; out RecordTag: string; out Sample: IXMLNode): Boolean;
   function LocalOrNodeName(const N: IXMLNode): string;
   function CampoTemMenosDeTresCaracteres(psCampo : string) : boolean;

implementation

uses
  Vcl.Forms;

const
  CODIGOTECLA_ENTER = #13;
  CODIGOANULA_TECLA = #0;

procedure TrocaTabPorEnter(var Key: Char);
begin
  if Key = CODIGOTECLA_ENTER then
  begin
    Key := CODIGOANULA_TECLA;
    if Assigned(Screen.ActiveForm) then
      Screen.ActiveForm.Perform(WM_NEXTDLGCTL, 0, 0);
  end;
end;

function SomenteNumeros(const Texto: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(Texto) do
    if Texto[i] in ['0'..'9'] then
      Result := Result + Texto[i];
end;

procedure CarregarJSONNoMemTable(
  const AJSONArray: TJSONArray; const AMemTable: TFDAdaptedDataset);
var
  i, j: Integer;
  JSONObj: TJSONObject;
  Pair: TJSONPair;
  FieldName: string;
begin
  if AJSONArray.Count = 0 then
    Exit;

  // Garante que é um TFDMemTable
  if not (AMemTable is TFDMemTable) then
    raise Exception.Create('DataSet deve ser do tipo TFDMemTable');

  with TFDMemTable(AMemTable) do
  begin
    Close;
    FieldDefs.Clear;

    // Cria os campos com base no primeiro objeto JSON
    if AJSONArray.Count > 0 then
    begin
      JSONObj := AJSONArray.Items[0] as TJSONObject;
      for j := 0 to JSONObj.Count - 1 do
      begin
        FieldName := JSONObj.Pairs[j].JsonString.Value;
        FieldDefs.Add(FieldName, ftString, 255); // Você pode tentar adivinhar o tipo depois
      end;
    end;

    CreateDataSet;
    Open;

    // Adiciona os registros
    for i := 0 to AJSONArray.Count - 1 do
    begin
      JSONObj := AJSONArray.Items[i] as TJSONObject;
      Append;
      for j := 0 to JSONObj.Count - 1 do
      begin
        Pair := JSONObj.Pairs[j];
        FieldName := Pair.JsonString.Value;
        Fields.FieldByName(FieldName).AsString := Pair.JsonValue.Value;
      end;
      Post;
    end;
  end;
end;

function ChildLocalOrNodeName(const N: IXMLNode): string;
begin
  if (N <> nil) and (N.LocalName <> '') then
    Result := N.LocalName
  else if N <> nil then
    Result := N.NodeName
  else
    Result := '';
end;

procedure CarregarXMLNoMemTable(const  AXmlDoc: string; const AMemTable: TFDMemTable);
var
  Doc                     : IXMLDocument;
  Root, Container, Item   : IXMLNode;
  Sample, Child           : IXMLNode;
  RecordTag, FieldName    : string;
  i, j, k, LeafAtRoot     : Integer;
  SS                      : TStringStream;
begin
  // Garante acentuação correta (ex.: "até")
  SS := TStringStream.Create(AXmlDoc, TEncoding.UTF8);
  try
    Doc := TXMLDocument.Create(nil);
    Doc.Options := Doc.Options + [doNodeAutoCreate, doNodeAutoIndent];
    Doc.LoadFromStream(SS);
    Doc.Active := True;
  finally
    SS.Free;
  end;

  Root := Doc.DocumentElement;
  if Root = nil then
    raise Exception.Create('XML sem elemento raiz.');

  // ---------- CASO 1: ROOT é um único registro (filhos folha) ----------
  LeafAtRoot := 0;
  for i := 0 to Root.ChildNodes.Count - 1 do
    if IsLeafElement(Root.ChildNodes[i]) then Inc(LeafAtRoot);

  AMemTable.DisableControls;
  try
    AMemTable.Close;
    AMemTable.FieldDefs.Clear;

    if LeafAtRoot > 0 then
    begin
      // cria campos pelos filhos folha de <xmlcep>
      for i := 0 to Root.ChildNodes.Count - 1 do
      begin
        Child := Root.ChildNodes[i];
        if IsLeafElement(Child) then
        begin
          FieldName := LocalOrNodeName(Child);
          if (FieldName <> '') and (AMemTable.FieldDefs.IndexOf(FieldName) = -1) then
            AMemTable.FieldDefs.Add(FieldName, ftString, 255);
        end;
      end;

      if AMemTable.FieldDefs.Count = 0 then
        raise Exception.Create('Não foi possível inferir campos do XML (registro único).');

      AMemTable.CreateDataSet;
      AMemTable.Open;

      AMemTable.Append;
      for j := 0 to AMemTable.FieldDefs.Count - 1 do
      begin
        FieldName := AMemTable.FieldDefs[j].Name;

        Child := Root.ChildNodes.FindNode(FieldName);
        if Child = nil then
          for k := 0 to Root.ChildNodes.Count - 1 do
            if IsElement(Root.ChildNodes[k]) and SameText(LocalOrNodeName(Root.ChildNodes[k]), FieldName) then
            begin
              Child := Root.ChildNodes[k];
              Break;
            end;

        if Child <> nil then
          AMemTable.Fields[j].AsString := NodeTextSafe(Child)
        else if Root.HasAttribute(FieldName) then
          AMemTable.Fields[j].AsString := VarToStr(Root.Attributes[FieldName])
        else
          AMemTable.Fields[j].Clear;
      end;
      AMemTable.Post;

      Exit; // já resolvido (registro único)
    end;

    // ---------- CASO 2: lista de registros (um nível 0 ou 1 abaixo) ----------
    if not TryDetectList(Root, Container, RecordTag, Sample) then
      raise Exception.Create('Não foi possível identificar a lista de registros no XML.');

    // cria campos pelos filhos folha do sample
    for i := 0 to Sample.ChildNodes.Count - 1 do
    begin
      Child := Sample.ChildNodes[i];
      if IsLeafElement(Child) then
      begin
        FieldName := LocalOrNodeName(Child);
        if (FieldName <> '') and (AMemTable.FieldDefs.IndexOf(FieldName) = -1) then
          AMemTable.FieldDefs.Add(FieldName, ftString, 255);
      end;
    end;

    if AMemTable.FieldDefs.Count = 0 then
      raise Exception.Create('Não foi possível inferir campos dos registros.');

    AMemTable.CreateDataSet;
    AMemTable.Open;

    AMemTable.BeginBatch;
    try
      for i := 0 to Container.ChildNodes.Count - 1 do
      begin
        Item := Container.ChildNodes[i];
        if not (IsElement(Item) and SameText(LocalOrNodeName(Item), RecordTag)) then
          Continue;

        AMemTable.Append;
        for j := 0 to AMemTable.FieldDefs.Count - 1 do
        begin
          FieldName := AMemTable.FieldDefs[j].Name;

          Child := Item.ChildNodes.FindNode(FieldName);
          if Child = nil then
            for k := 0 to Item.ChildNodes.Count - 1 do
              if IsElement(Item.ChildNodes[k]) and SameText(LocalOrNodeName(Item.ChildNodes[k]), FieldName) then
              begin
                Child := Item.ChildNodes[k];
                Break;
              end;

          if Child <> nil then
            AMemTable.Fields[j].AsString := NodeTextSafe(Child)
          else if Item.HasAttribute(FieldName) then
            AMemTable.Fields[j].AsString := VarToStr(Item.Attributes[FieldName])
          else
            AMemTable.Fields[j].Clear;
        end;
        AMemTable.Post;
      end;
    finally
      AMemTable.EndBatch;
    end;

  finally
    AMemTable.EnableControls;
  end;
end;

function IsLeafElement(const N: IXMLNode): Boolean;
begin
  Result := IsElement(N) and (
             (not N.HasChildNodes) or
             ((N.ChildNodes.Count = 1) and
              (N.ChildNodes[0].NodeType in [ntText, ntCData]))
           );
end;

function IsElement(const N: IXMLNode): Boolean;
begin
  Result := (N <> nil) and (N.NodeType = ntElement);
end;


function NodeTextSafe(const N: IXMLNode): string;
begin
  if N = nil then Exit('');
  try
    if not VarIsNull(N.NodeValue) then
      Exit(VarToStr(N.NodeValue));
  except end;
  Result := N.Text;
end;

function LocalOrNodeName(const N: IXMLNode): string;
begin
  if (N <> nil) and (N.LocalName <> '') then
    Result := N.LocalName
  else if N <> nil then
    Result := N.NodeName
  else
    Result := '';
end;

// Tenta detectar automaticamente onde está a lista e qual é a tag de "registro"
function TryDetectList(const Root: IXMLNode; out Container: IXMLNode; out RecordTag: string; out Sample: IXMLNode): Boolean;
var
  i, j, k, LeafCnt: Integer;
  L1, L2: IXMLNode;
begin
  Result := False;
  Container := nil; RecordTag := ''; Sample := nil;

  // Caso 1: registros diretamente sob a raiz
  for i := 0 to Root.ChildNodes.Count - 1 do
  begin
    L1 := Root.ChildNodes[i];
    if not IsElement(L1) then Continue;

    LeafCnt := 0;
    for j := 0 to L1.ChildNodes.Count - 1 do
      if IsLeafElement(L1.ChildNodes[j]) then Inc(LeafCnt);

    if LeafCnt > 0 then
    begin
      Container := Root;
      RecordTag := LocalOrNodeName(L1);
      Sample    := L1;
      Exit(True);
    end;
  end;

  // Caso 2: registros um nível abaixo (ex.: <enderecos><endereco>…)
  for i := 0 to Root.ChildNodes.Count - 1 do
  begin
    L1 := Root.ChildNodes[i];
    if not IsElement(L1) then Continue;

    for j := 0 to L1.ChildNodes.Count - 1 do
    begin
      L2 := L1.ChildNodes[j];
      if not IsElement(L2) then Continue;

      LeafCnt := 0;
      for k := 0 to L2.ChildNodes.Count - 1 do
        if IsLeafElement(L2.ChildNodes[k]) then Inc(LeafCnt);

      if LeafCnt > 0 then
      begin
        Container := L1;
        RecordTag := LocalOrNodeName(L2);
        Sample    := L2;
        Exit(True);
      end;
    end;
  end;
end;

function CampoTemMenosDeTresCaracteres(psCampo : string) : boolean;
begin
   result := psCampo.Length < 3;
end;

end.
