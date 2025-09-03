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

unit Lca.Orm.GerarClasse.BancoFirebird;

interface

uses
  Lca.Orm.Base, DB, SysUtils, Classes;

type
  TGerarClasseBancoFirebird = class(TInterfacedObject, IBaseGerarClasseBanco)
  private
    function GetTypeField(Tipo, SubTipo, Precisao, Escala: Integer): string;
  public
     //obtem sql com nome, tamanho e tipo dos campos
    function GetSQLCamposTabela(ATabela: string): string;

    //obtem sql com chave prim�rias
    function GetSQLCamposPK(ATabela: string): string;

    procedure GerarFields(Ads: TDataSet; AResult: TStrings);
    procedure GerarProperties(Ads: TDataSet; AResult: TStrings; ACamposPK: string);
  end;

implementation

{ TGerarClasseIBX }

procedure TGerarClasseBancoFirebird.GerarFields(Ads: TDataSet; AResult: TStrings);
var
  Tipo,
  SubTipo,
  Precisao,
  Escala: Integer;
  Nome: string;
begin
  AResult.Add('  private');
  ADs.First;
  while not Ads.eof do
  begin
    Tipo := Ads.FieldByName('tipo').AsInteger;
    SubTipo := Ads.FieldByName('subtipo').AsInteger;
    Precisao := Ads.FieldByName('precisao').AsInteger;
    Escala := Ads.FieldByName('escala').AsInteger;
    Nome := Trim(Ads.FieldByName('nome').AsString);
    Nome := 'F' + UpperCase(Nome[1]) + LowerCase(Copy(Nome, 2, Length(Nome)));
    AResult.Add('    ' + Nome + ': ' + GetTypeField(Tipo, SubTipo, Precisao, Escala) + ';');
    Ads.Next;
  end;
end;

procedure TGerarClasseBancoFirebird.GerarProperties(Ads: TDataSet; AResult: TStrings; ACamposPK: string);
var
  Tipo,
  SubTipo,
  Precisao,
  Escala: Integer;
  Nome: string;
begin
  AResult.Add('  public');
  ADs.First;
  while not Ads.eof do
  begin
    Tipo := Ads.FieldByName('tipo').AsInteger;
    SubTipo := Ads.FieldByName('subtipo').AsInteger;
    Precisao := Ads.FieldByName('precisao').AsInteger;
    Escala := Ads.FieldByName('escala').AsInteger;
    Nome := Trim(Ads.FieldByName('nome').AsString);

    if pos(Nome, ACamposPK) > 0 then
      AResult.Add('    [attPK]');

    Nome := UpperCase(Nome[1]) + LowerCase(Copy(Nome, 2, Length(Nome)));

    AResult.Add('    property ' +
                       Nome +': ' + GetTypeField(Tipo, SubTipo, Precisao, Escala) +
                       ' read F' + Nome +
                       ' write F' + Nome + ';');
    Ads.Next;
  end;
end;

function TGerarClasseBancoFirebird.GetSQLCamposPK(ATabela: string): string;
begin
  Result := 'SELECT RDB$RELATION_CONSTRAINTS.RDB$RELATION_NAME AS TABELA, ' +
            'RDB$RELATION_CONSTRAINTS.RDB$CONSTRAINT_NAME AS CHAVE, ' +
            'RDB$RELATION_CONSTRAINTS.RDB$INDEX_NAME AS INDICE_DA_CHAVE, ' +
            'RDB$INDEX_SEGMENTS.RDB$FIELD_NAME AS CAMPO, ' +
            'RDB$INDEX_SEGMENTS.RDB$FIELD_POSITION AS POSICAO ' +
            'FROM RDB$RELATION_CONSTRAINTS, ' +
            'RDB$INDICES, ' +
            'RDB$INDEX_SEGMENTS ' +
            'WHERE RDB$RELATION_CONSTRAINTS.RDB$CONSTRAINT_TYPE = ''PRIMARY KEY'' ' +
            'AND RDB$RELATION_CONSTRAINTS.RDB$RELATION_NAME = ' + QuotedStr(ATabela) +
            'AND RDB$RELATION_CONSTRAINTS.RDB$INDEX_NAME = RDB$INDICES.RDB$INDEX_NAME ' +
            'AND RDB$INDEX_SEGMENTS.RDB$INDEX_NAME = RDB$INDICES.RDB$INDEX_NAME ' +
            'ORDER BY RDB$RELATION_CONSTRAINTS.RDB$CONSTRAINT_NAME, ' +
            'RDB$INDEX_SEGMENTS.RDB$FIELD_POSITION';
end;

function TGerarClasseBancoFirebird.GetSQLCamposTabela(ATabela: string): string;
begin
  Result := 'SELECT r.RDB$FIELD_NAME AS nome,' +
            'r.RDB$DESCRIPTION AS descricao,' +
            'f.RDB$FIELD_LENGTH AS tamanho,' +
            'f.RDB$FIELD_TYPE AS tipo,' +
            'f.RDB$FIELD_SUB_TYPE AS subtipo, ' +
            'f.RDB$FIELD_PRECISION AS precisao, ' +
            'f.RDB$FIELD_SCALE AS escala '+
            'FROM RDB$RELATION_FIELDS r ' +
            'LEFT JOIN RDB$FIELDS f ON r.RDB$FIELD_SOURCE = f.RDB$FIELD_NAME ' +
            'WHERE r.RDB$RELATION_NAME='+ QuotedStr(ATabela) + ' ' +
            'ORDER BY r.RDB$FIELD_POSITION;';
end;

function TGerarClasseBancoFirebird.GetTypeField(Tipo, SubTipo, Precisao, Escala: Integer): string;
begin
  case Tipo of
    7,
    8,
    9,
    10,
    11,
    16,
    27: begin
          case Escala of
            0: Result := 'Integer';
           -8: Result := 'Double';
          else
            Result := 'Currency';
          end
        end;
    14,
    37,
    40: Result := 'string';
    12: Result := 'TDate';
    13: Result := 'TTime';
    35: Result := 'TDateTime';
    261:
    begin
      if SubTipo = 1 then
        Result := 'string'
      else
        Result := 'Blob';
    end;
  end;
end;

end.
