unit TestPrsDaoGerarClasse;

interface

uses
  TestFramework, system.Generics.Collections, Lca.Orm.Base, FireDAC.Stan.Error,
  FireDAC.Stan.Intf, FireDAC.DApt, FireDAC.VCLUI.Wait, Rtti, FireDAC.Stan.Async,
  FireDAC.DatS, FireDAC.UI.Intf, Lca.Orm.Comp.FireDac, FireDAC.Stan.Param,
  FireDAC.Comp.Client, FireDAC.Phys, FireDAC.Stan.Pool, FireDAC.Stan.Option,
  system.Classes, Lca.Orm.Atributos, FireDAC.Comp.DataSet, FireDAC.Stan.Def,
  FireDAC.DApt.Intf, Db, FireDAC.Phys.FB, system.SysUtils, FireDAC.Phys.FBDef,
  FireDAC.Phys.Intf, Cidade, udmPrin;

type
  TestGerarClasseFireDac = class(TTestCase)
  strict private
    FDao: TDaoFireDac;
    FDm: TdmPrin;
    FResultado: string;
  private
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestGerarClasse;
    procedure TestCabecalho;
    procedure TestClasse;
    procedure TestRodapeDaUnit;
  end;

implementation

uses Vcl.Dialogs;


procedure TestGerarClasseFireDac.TestGerarClasse;
begin
  CheckTrue(FResultado<>'', 'Nenhuma Classe Gerada');
end;

procedure TestGerarClasseFireDac.TestCabecalho;
begin
  CheckEqualsString('unit', copy(FResultado, 1,4), 'Unit inv�lida!');
  CheckTrue(pos('interface', FResultado)>0, 'Cabe�alho inv�lido! Interface n�o consta na unit.');
  CheckTrue(pos('type', FResultado)>0, 'Cabe�alho inv�lido! Type n�o consta na unit.');
end;

procedure TestGerarClasseFireDac.TestClasse;
begin
  CheckTrue(pos('[attTabela(''CIDADE'')]', FResultado)>0, 'Cabe�alho inv�lido! Atributo nome da tabela n�o consta na unit.');
  CheckTrue(pos('TCidade', FResultado)>0, 'Classe TCidade n�o consta na unit.');
  CheckTrue(pos('private', FResultado)>0, 'Private n�o consta na unit.');
  CheckTrue(pos('public', FResultado)>0, 'Public n�o consta na unit.');
  CheckTrue(pos('[attPK]', FResultado)>0, 'Atributo de chave prim�ria n�o consta na unit.');
  CheckTrue(pos('property Id', FResultado)>0, 'Property Id n�o consta na unit.');
  CheckTrue(pos('property Nome', FResultado)>0, 'Property Nome n�o consta na unit.');
  CheckTrue(pos('property Uf', FResultado)>0, 'Property Uf n�o consta na unit.');
  CheckTrue(pos('property Ibge', FResultado)>0, 'Property Ibge n�o consta na unit.');
  CheckTrue(pos('property Datacad', FResultado)>0, 'Property Datacad n�o consta na unit.');
end;

procedure TestGerarClasseFireDac.TestRodapeDaUnit;
begin
  CheckTrue(pos('implementation', FResultado)>0, 'Implementation n�o consta na unit.');
  CheckEqualsString('end.',copy(FResultado, Length(FResultado) - 5, 4));
end;

procedure TestGerarClasseFireDac.SetUp;
begin
  FDm := TdmPrin.Create(nil);
  FDm.FDConnection1.Connected := true;
  FDao := TDaoFireDac.Create(FDm.FDConnection1, FDm.ttt);
  FResultado := FDao.GerarClasse('CIDADE', 'CIDADE', '');
end;

procedure TestGerarClasseFireDac.TearDown;
begin
  FDm.Free;
  FDm := nil;
  FDao.Free;
  FDao := nil;
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestGerarClasseFireDac.Suite);
end.

