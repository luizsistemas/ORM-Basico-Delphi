{******************************************************************************}
{ Projeto: ORM - Básico do Blog do Luiz                                        }
{ Este projeto busca agilizar o processo de manipulação de dados (DAO/CRUD),   }
{ ou seja,  gerar inserts, updates, deletes nas tabelas de forma automática,   }
{ sem a necessidade de criarmos classes DAOs para cada tabela. Também visa     }
{ facilitar a transição de uma suite de componentes de acesso a dados para     }
{ outra.                                                                       }
{                                                                              }
{ Direitos Autorais Reservados (c) 2014 Luiz Carlos Alves                      }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{    Luiz Carlos Alves - contato@luizsistemas.com.br                           }
{                                                                              }
{ Você pode obter a última versão desse arquivo no repositório                 }
{ https://github.com/luizsistemas/ORM-Basico-Delphi                            }
{                                                                              }
{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }
{                                                                              }
{ Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }
{                                                                              }
{ Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Luiz Carlos Alves - contato@luizsistemas.com.br -  www.luizsistemas.com.br   }
{                                                                              }
{******************************************************************************}
unit Lca.Orm.GerarClasse;

interface

uses
  Lca.Orm.Base, Classes;

type
  TGerarClasse = class
  private
    function Capitalize(ATexto: String): string;
  protected
    Resultado: TStringList;
    GerarClasseBanco: IBaseGerarClasseBanco;

    FTabela,
    FUnit,
    FClasse: string;

    function GetCamposPK: string; virtual; abstract;

    procedure GerarCabecalho;
    procedure GerarFieldsProperties; virtual; abstract;
    procedure GerarRodape;
  public
    constructor Create(AClasseBanco: IBaseGerarClasseBanco);
    destructor Destroy; override;

    function Gerar(ATabela, ANomeUnit: string;
      ANomeClasse: string = ''): string;
  end;

implementation

{ TGerarClasse }

uses SysUtils;

function TGerarClasse.Capitalize(ATexto: String): string;
begin
  Result := UpperCase(ATexto[1]) + LowerCase(Copy(ATexto, 2, Length(ATexto)));
end;

constructor TGerarClasse.Create(AClasseBanco: IBaseGerarClasseBanco);
begin
  inherited Create;
  Resultado := TStringList.Create;
  GerarClasseBanco := AClasseBanco;
end;

destructor TGerarClasse.Destroy;
begin
  Resultado.Free;
  inherited;
end;

function TGerarClasse.Gerar(ATabela, ANomeUnit, ANomeClasse: string): string;
begin
  FTabela := ATabela;

  FUnit := Capitalize(ANomeUnit);

  if Trim(ANomeClasse) = '' then
    FClasse := Capitalize(FTabela)
  else
    FClasse := Capitalize(ANomeClasse);

  GerarCabecalho;

  GerarFieldsProperties;

  GerarRodape;

  Result := Resultado.Text;
end;

procedure TGerarClasse.GerarCabecalho;
begin
  Resultado.clear;
  Resultado.add('unit ' + FUnit + ';');
  Resultado.add('');
  Resultado.add('interface');
  Resultado.add('');
  Resultado.add('uses');
  Resultado.add('  Lca.Orm.Base, Lca.Orm.Atributos;');
  Resultado.add('');
  Resultado.add('type');
  Resultado.add('  [attTabela(' + QuotedStr(FTabela) + ')]');
  Resultado.add('  T' + FClasse + ' = class(TTabela)');
end;

procedure TGerarClasse.GerarRodape;
begin
  Resultado.Add('  end;');
  Resultado.Add('');
  Resultado.Add('implementation');
  Resultado.Add('');
  Resultado.Add('end.');
end;

end.
