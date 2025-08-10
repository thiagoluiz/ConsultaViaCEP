unit uIRequestStrategy;

interface

uses
  uEnderecoRequest;

type
  IRequestStrategy = interface
    function BuildUrl(ARequest: TEnderecoRequest): string;
  end;

implementation

end.
