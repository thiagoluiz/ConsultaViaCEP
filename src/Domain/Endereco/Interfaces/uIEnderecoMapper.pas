unit uIEnderecoMapper;

interface

uses
  uEndereco;

type
  IEnderecoMapper<T> = interface
    function MapToEndereco(AContent: T): TEndereco;
  end;

implementation

end.
