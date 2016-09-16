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

unit Lca.Orm.GerarClasse.BancoFirebird;

interface

uses
  Lca.Orm.Base, DB, SysUtils, Classes;

type
  TGerarClasseBancoFirebird = class(TInterfacedObject, IBaseGerarClasseBanco)
  private
    function GetTypeField(Tipo, SubTipo, Precisao: Integer): string;
  public
     //obtem sql com nome, tamanho e tipo dos campos
    function GetSQLCamposTabela(ATabela: string): string;

    //obtem sql com chave primárias
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
  Precisao: Integer;
  Nome: string;
begin
  AResult.Add('  private');
  ADs.First;
  while not Ads.eof do
  begin
    Tipo := Ads.FieldByName('tipo').AsInteger;
    SubTipo := Ads.FieldByName('subtipo').AsInteger;
    Precisao := Ads.FieldByName('precisao').AsInteger;
    Nome := Trim(Ads.FieldByName('nome').AsString);
    Nome := 'F' + UpperCase(Nome[1]) + LowerCase(Copy(Nome, 2, Length(Nome)));
    AResult.Add('    ' + Nome + ': ' + GetTypeField(Tipo, SubTipo, Precisao) + ';');
    Ads.Next;
  end;
end;

procedure TGerarClasseBancoFirebird.GerarProperties(Ads: TDataSet; AResult: TStrings; ACamposPK: string);
var
  Tipo,
  SubTipo,
  Precisao: Integer;
  Nome: string;
begin
  AResult.Add('  public');
  ADs.First;
  while not Ads.eof do
  begin
    Tipo := Ads.FieldByName('tipo').AsInteger;
    SubTipo := Ads.FieldByName('subtipo').AsInteger;
    Precisao := Ads.FieldByName('precisao').AsInteger;
    Nome := Trim(Ads.FieldByName('nome').AsString);

    if pos(Nome, ACamposPK) > 0 then
      AResult.Add('    [attPK]');

    Nome := UpperCase(Nome[1]) + LowerCase(Copy(Nome, 2, Length(Nome)));

    AResult.Add('    property ' +
                       Nome +': ' + GetTypeField(Tipo, SubTipo, Precisao) +
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
            'f.RDB$FIELD_PRECISION AS precisao ' +
            'FROM RDB$RELATION_FIELDS r ' +
            'LEFT JOIN RDB$FIELDS f ON r.RDB$FIELD_SOURCE = f.RDB$FIELD_NAME ' +
            'WHERE r.RDB$RELATION_NAME='+ QuotedStr(ATabela) + ' ' +
            'ORDER BY r.RDB$FIELD_POSITION;';
end;

function TGerarClasseBancoFirebird.GetTypeField(Tipo, SubTipo, Precisao: Integer): string;
begin
  case Tipo of
    7,
    8,
    9,
    10,
    11,
    16,
    27: begin
          if Precisao = 0 then
            Result := 'Integer'
          else
            Result := 'Currency';
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
