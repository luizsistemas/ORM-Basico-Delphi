{******************************************************************************}
{ Projeto: ORM - B�sico do Blog do Luiz                                        }
{ Este projeto busca agilizar o processo de manipula��o de dados (DAO/CRUD),   }
{ ou seja,  gerar inserts, updates, deletes nas tabelas de forma autom�tica,   }
{ sem a necessidade de criarmos classes DAOs para cada tabela. Tamb�m visa     }
{ facilitar a transi��o de uma suite de componentes de acesso a dados para     }
{ outra.                                                                       }
{                                                                              }
{ Direitos Autorais Reservados (c) 2014 Luiz Carlos Alves                      }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{    Luiz Carlos Alves - contato@luizsistemas.com.br                           }
{                                                                              }
{ Voc� pode obter a �ltima vers�o desse arquivo no reposit�rio                 }
{ https://github.com/luizsistemas/ORM-Basico-Delphi                            }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{ Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{ Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
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

    function Gerar(ATabela, ANomeUnit: string; ANomeClasse: string = ''): string;
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
