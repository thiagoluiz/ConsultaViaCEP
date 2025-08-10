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

📂 Application
├── Services # Casos de uso (coordenação das operações)
└── DTOs # Objetos de transferência de dados

📂 Domain
├── Entities # Entidades de negócio
├── Interfaces # Interfaces de repositórios e serviços
└── Enums # Tipos e constantes de domínio

📂 Infrastructure
├── Repositories # Implementações de acesso a dados
├── Mappers # Conversão entre formatos (JSON/XML -> Objetos)
└── HttpClients # Consumo da API ViaCEP

📂 IoC
└── Container # Registro das injeções de dependência (Spring4D)

📂 Presentation
└── Forms # Interface gráfica com o usuário



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
