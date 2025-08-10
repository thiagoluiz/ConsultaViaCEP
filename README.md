# 📍 Consulta de Endereços - ViaCEP

Projeto desenvolvido em **Delphi** para realizar consultas de endereços através da API pública do [ViaCEP](https://viacep.com.br), com suporte a retorno em **JSON** ou **XML**.  
O sistema segue princípios de **Clean Code** e **SOLID**, utilizando **DDD (Domain-Driven Design)** e padrões de projeto para garantir manutenibilidade e escalabilidade.

---

## 🚀 Funcionalidades

- Consulta de endereço por **CEP**.
- Consulta de CEP por **endereço completo** (UF, cidade e logradouro).
- Suporte a múltiplos formatos de retorno (**JSON** e **XML**).
- Persistência dos resultados em banco de dados **Firebird**.
- Tratamento de erros e validação de indisponibilidade do ViaCEP.
- Arquitetura modular com injeção de dependência via **Spring4D**.

---

## 🛠 Tecnologias Utilizadas

- **Delphi** (versão mais recente utilizada no projeto)
- **Spring4D** (Injeção de Dependência)
- **FireDAC** (acesso a banco de dados)
- **Firebird** (persistência dos dados)
- **System.Net.HttpClient** (consumo de APIs externas)
- **System.JSON** (parse de dados JSON)
- **XMLDoc** / **IXMLDocument** (parse de dados XML)

---

## 🏛 Arquitetura

O projeto segue a arquitetura **DDD (Domain-Driven Design)** com separação em camadas:

📂 **Aplicativo**  
  📄 **Serviços** — Casos de uso (coordenação das operações)  
  📄 **DTOs** — Objetos de transferência de dados  

📂 **Domínio**  
  📄 **Entidades** — Entidades de negócio  
  📄 **Interfaces** — Interfaces de repositórios e serviços  
  📄 **Enums** — Tipos e constantes de domínio  

📂 **Infraestrutura**  
  📄 **Repositórios** — Implementações de acesso a dados  
  📄 **Mappers** — Conversão entre formatos (JSON/XML → Objetos)  
  📄 **HttpClients** — Consumo da API ViaCEP  

📂 **IoC**  
  📄 **Container** — Registro das injeções de dependência (Spring4D)  

📂 **Apresentação**  
  📄 **Formulários** — Interface gráfica com o usuário  




---

## 🎯 Padrões de Projeto Aplicados

- **Repository** → abstração da persistência em banco de dados.
- **Strategy** → seleção dinâmica do formato de retorno (JSON ou XML).
- **Factory Method** → criação da estratégia de parsing via `TFormatStrategyFactory`.
- **Mediator** → coordenação das chamadas entre interface e camada de aplicação.
- **Dependency Injection (IoC)** → gerenciamento das dependências via Spring4D.

---

## ⚙️ Como Executar o Projeto

### 1️⃣ Pré-requisitos
- **Delphi** (versão mais recente)
- **Firebird** (versão 3 ou superior)
- **Spring4D** configurado no Delphi
- Banco de dados criado com a tabela de endereços:

### 1️⃣ Criação da Tabela

Execute o script SQL abaixo no seu banco de dados **Firebird** para criar a tabela utilizada pelo projeto:

```sql
CREATE TABLE ENDERECOS (
    CEP VARCHAR(9) NOT NULL PRIMARY KEY,
    LOGRADOURO VARCHAR(255),
    COMPLEMENTO VARCHAR(255),
    BAIRRO VARCHAR(255),
    LOCALIDADE VARCHAR(255),
    UF VARCHAR(2),
    IBGE VARCHAR(10),
    GIA VARCHAR(10),
    DDD VARCHAR(5),
    SIAFI VARCHAR(10)
);


### 2️⃣ Configuração da Conexão
Edite a unidade de conexão no DataModule: DmMaster, Componente: ConexaoPrinciapl  para apontar para o seu banco de dados Firebird:
FDConnection.Params.DriverID := 'FB';
FDConnection.Params.Database := 'C:\caminho\para\banco.fdb';
FDConnection.Params.UserName := 'SYSDBA';
FDConnection.Params.Password := 'masterkey';


### 3️⃣ Configuração do Library Path
Para que o Delphi encontre as bibliotecas utilizadas (como Spring4D), é necessário configurar o Library Path:

No Delphi, vá em:
Tools → Options → Language → Delphi → Library → Library Path
Adicione o caminho onde está instalado o Spring4D, por exemplo:

C:\libs\spring4d\Source
Salve e feche a janela.

💡 Dica: mantenha as bibliotecas em uma pasta separada do seu código para facilitar manutenção e atualização.
