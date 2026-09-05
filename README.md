# SecureDelivery Mobile

Aplicativo mobile do **SecureDelivery**, desenvolvido com **Flutter e Dart**.

O aplicativo será utilizado no monitoramento do dispositivo IoT durante as entregas, incluindo sensores, localização, detecção de eventos, telemetria, armazenamento local e sincronização com o backend.

> 🚧 **Projeto em desenvolvimento — MVP**

---

## Plataformas suportadas

O SecureDelivery Mobile possui como plataformas oficiais:

* **Android**
* **iOS**

> Web, Windows, Linux e macOS não fazem parte dos targets do produto.

---

## Requisitos

Para executar e desenvolver o projeto localmente, é necessário ter:

* Git
* Flutter
* Dart
* Android Studio para desenvolvimento Android
* Xcode para desenvolvimento iOS
* macOS para compilação e desenvolvimento nativo de iOS

> O Dart já acompanha o Flutter, portanto normalmente não é necessário instalá-lo separadamente.

---

# Configuração do ambiente

## Android

Para desenvolvimento Android, instale:

1. Git
2. Flutter
3. Android Studio
4. Android SDK
5. Um dispositivo Android físico ou um emulador

Documentação oficial do Flutter:

[Instalação do Flutter para Android](https://docs.flutter.dev/get-started/install?utm_source=chatgpt.com)

Depois de instalar o Flutter, verifique:

```bash
flutter --version
dart --version
```

Verifique o ambiente:

```bash
flutter doctor
```

Configure o Android SDK pelo Android Studio e aceite as licenças necessárias:

```bash
flutter doctor --android-licenses
```

Depois verifique os dispositivos disponíveis:

```bash
flutter devices
```

---

## iOS

O desenvolvimento e a compilação para iOS exigem **macOS e Xcode**.

Instale:

1. Git
2. Flutter
3. Xcode
4. CocoaPods, quando necessário pelas dependências utilizadas

Documentação oficial:

[Instalação do Flutter para iOS](https://docs.flutter.dev/get-started/install/macos?utm_source=chatgpt.com)

Verifique o ambiente:

```bash
flutter doctor
```

Depois verifique os dispositivos disponíveis:

```bash
flutter devices
```

Para desenvolvimento iOS, pode ser utilizado:

* iPhone físico
* iOS Simulator

> Um ambiente Linux ou Windows pode ser utilizado para desenvolvimento geral do código Flutter, mas a compilação e os testes nativos de iOS dependem de macOS e Xcode.

---

# Configurando o projeto

Clone o repositório:

```bash
git clone <repository-url>
```

Entre no projeto:

```bash
cd securedelivery-mobile
```

Instale as dependências:

```bash
flutter pub get
```

Verifique o ambiente:

```bash
flutter doctor
```

Liste os dispositivos disponíveis:

```bash
flutter devices
```

---

# Ambientes

O projeto possui três ambientes:

* `development`
* `staging`
* `production`

A seleção do ambiente é feita através de:

```text
APP_ENV
```

O ambiente padrão é `development`.

Atualmente os ambientes possuem a estrutura de configuração preparada, enquanto as URLs e configurações específicas do backend ainda serão definidas conforme o contrato da API.

---

## Android Flavors

O Android possui três flavors:

| Flavor        | Application ID                                     | Uso             |
| ------------- | -------------------------------------------------- | --------------- |
| `development` | `com.securedelivery.securedelivery_mobile.dev`     | Desenvolvimento |
| `staging`     | `com.securedelivery.securedelivery_mobile.staging` | Homologação     |
| `production`  | `com.securedelivery.securedelivery_mobile`         | Produção        |

Para executar cada ambiente:

### Development

```bash
flutter run --flavor development --dart-define=APP_ENV=development
```

### Staging

```bash
flutter run --flavor staging --dart-define=APP_ENV=staging
```

### Production

```bash
flutter run --flavor production --dart-define=APP_ENV=production
```

> A configuração de assinatura de release ainda precisa ser substituída pela assinatura de produção antes de um lançamento oficial.

---

# iOS Environments

Os ambientes `development`, `staging` e `production` também deverão existir no iOS.

A configuração equivalente será implementada no projeto Xcode utilizando as configurações apropriadas de build/scheme.

O objetivo é manter o mesmo conceito de ambientes entre Android e iOS:

```text
development
staging
production
```

---

# Executando o projeto

Primeiro verifique os dispositivos:

```bash
flutter devices
```

Para executar o aplicativo no dispositivo selecionado:

```bash
flutter run
```

Caso existam vários dispositivos:

```bash
flutter run -d <device-id>
```

Por exemplo:

```bash
flutter run -d emulator-5554
```

> Os comandos acima dependem de um dispositivo Android ou iOS disponível.

---

# Testes

Execute todos os testes automatizados:

```bash
flutter test
```

Para uma saída mais detalhada:

```bash
flutter test -r expanded
```

Para gerar cobertura:

```bash
flutter test --coverage
```

Os testes devem funcionar sem depender de hardware físico.

---

# Análise do código

Execute:

```bash
flutter analyze
```

O projeto deve terminar a análise sem problemas.

---

# Formatação

Para formatar o código:

```bash
dart format .
```

Para verificar a formatação sem alterar os arquivos:

```bash
dart format --set-exit-if-changed .
```

---

# Validação antes do commit

Antes de criar um commit, execute:

```bash
flutter pub get
dart format --set-exit-if-changed .
flutter analyze
flutter test --coverage
git diff --check
```

Todos os comandos devem terminar com sucesso.

---

# Estrutura do projeto

A estrutura atual do projeto é baseada em módulos e será expandida conforme as funcionalidades forem implementadas.

```text
securedelivery-mobile/
│
├── android/
├── ios/
│
├── lib/
│   ├── app/
│   │   └── environment/
│   │
│   ├── core/
│   │   └── logging/
│   │
│   ├── sensors/
│   │   └── models/
│   │
│   └── main.dart
│
├── test/
│   ├── core/
│   │   └── logging/
│   │
│   └── sensors/
│       └── models/
│
├── assets/
├── analysis_options.yaml
├── pubspec.yaml
└── README.md
```

## `lib/`

Contém o código principal do aplicativo.

### `lib/app/`

Responsável pela inicialização e configuração geral da aplicação.

Inclui atualmente:

* `SecureDeliveryApp`
* bootstrap da aplicação
* configuração de ambientes

### `lib/core/`

Contém componentes compartilhados pela aplicação.

Atualmente inclui o sistema básico de logging.

### `lib/sensors/`

Contém as abstrações relacionadas aos sensores.

Neste momento existe a abstração de sensor e o modelo de observação, mas **os sensores físicos ainda não foram implementados**.

### `test/`

Contém os testes automatizados.

Os testes devem ser independentes de hardware sempre que possível.

### `assets/`

Contém recursos utilizados pelo aplicativo.

### `android/`

Projeto nativo Android.

Contém a configuração dos flavors:

```text
development
staging
production
```

### `ios/`

Projeto nativo iOS.

As configurações de ambiente e integração nativa serão adicionadas conforme o desenvolvimento avançar.

---

# Arquitetura

O projeto está sendo desenvolvido com uma arquitetura modular.

A aplicação terá como principais responsabilidades:

* Monitoramento
* Sensores
* GPS
* Estado do dispositivo
* Detecção de eventos
* Evidências de eventos
* Telemetria
* Navegação
* Armazenamento local
* Sincronização
* Comunicação com o backend
* Segurança
* Ativação do dispositivo

As integrações com hardware e recursos específicos de Android/iOS devem permanecer atrás de abstrações sempre que possível.

Isso permite que a maior parte da lógica seja testada sem depender de dispositivos físicos.

---

# Estado atual do projeto

Atualmente o projeto possui a base para:

* Inicialização estruturada da aplicação
* Configuração de ambientes
* Android flavors
* Logging estruturado
* Abstração de sensores
* Modelo de observação de sensores
* Testes automatizados
* Análise estática
* Cobertura de testes
* Configuração de MCP para ferramentas de desenvolvimento

As funcionalidades de produção ainda serão implementadas incrementalmente.

---

# Limpeza do projeto

Para remover arquivos gerados pelo Flutter:

```bash
flutter clean
```

Depois reinstale as dependências:

```bash
flutter pub get
```

---

# Comandos principais

| Comando                   | Descrição                       |
| ------------------------- | ------------------------------- |
| `flutter pub get`         | Instala as dependências         |
| `flutter run`             | Executa o aplicativo            |
| `flutter devices`         | Lista dispositivos Android/iOS  |
| `flutter test`            | Executa os testes               |
| `flutter test --coverage` | Executa testes e gera cobertura |
| `flutter analyze`         | Analisa o código                |
| `dart format .`           | Formata o código                |
| `flutter doctor`          | Verifica o ambiente             |
| `flutter clean`           | Limpa arquivos gerados          |

---

# Fluxo básico para um novo desenvolvedor

Depois de clonar o projeto:

```bash
cd securedelivery-mobile
```

Instale as dependências:

```bash
flutter pub get
```

Verifique o ambiente:

```bash
flutter doctor
```

Verifique os dispositivos:

```bash
flutter devices
```

Execute a análise:

```bash
flutter analyze
```

Execute os testes:

```bash
flutter test
```

Execute o aplicativo:

```bash
flutter run
```

Para Android, utilize um dispositivo Android ou emulador.

Para iOS, utilize um Mac com Xcode e um iPhone físico ou iOS Simulator.

---

# Regras de desenvolvimento

O projeto deve seguir alguns princípios:

1. **Android e iOS são os únicos targets oficiais.**
2. Não implementar funcionalidades de produto sem uma definição clara do contrato.
3. Manter integrações de hardware atrás de abstrações.
4. Não depender de hardware físico nos testes unitários.
5. Não armazenar dados importantes somente em memória.
6. Não colocar credenciais ou secrets diretamente no código.
7. Alterações devem ser pequenas e independentes.
8. Toda alteração deve ser formatada, analisada e testada antes do commit.
9. Não criar workflows do GitHub Actions para este projeto sem decisão explícita da equipe.
10. Não implementar sensores físicos antes da definição dos contratos e regras de detecção.

---

# Status

**SecureDelivery Mobile — MVP em desenvolvimento.**

Plataformas oficiais:

**Android + iOS**
