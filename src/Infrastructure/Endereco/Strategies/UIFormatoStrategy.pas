unit UIFormatoStrategy;

interface

uses uEndereco;

type
  IFormatoStrategy<T> = interface
    function Parse(const AContent: string): T;
  end;

implementation

end.
