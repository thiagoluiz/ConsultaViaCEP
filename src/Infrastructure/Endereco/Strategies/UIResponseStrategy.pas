unit UIResponseStrategy;

interface

uses
  System.JSON, System.RTTI;

type
  IResponseStrategy<T> = interface
    function Parse(const AValue: TValue): T;
  end;

implementation

end.
