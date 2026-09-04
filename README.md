# SecureDelivery Mobile

Aplicativo mobile do **SecureDelivery**, desenvolvido com **Flutter e Dart**.

O projeto é responsável pela aplicação mobile utilizada no monitoramento do dispositivo IoT, incluindo sensores, localização, detecção de eventos, telemetria, armazenamento local e sincronização com o backend.

> 🚧 Projeto em desenvolvimento — MVP

---

## Requisitos

Para executar o projeto localmente, é necessário ter instalado:

* Git
* Flutter
* Dart
* Android Studio para desenvolvimento Android
* Xcode para desenvolvimento iOS (macOS)

> O Dart já acompanha o Flutter, portanto normalmente não é necessário instalá-lo separadamente.

---

# Instalação do ambiente

## Windows

### 1. Instalar Git

Baixe e instale o Git:

https://git-scm.com/download/win

### 2. Instalar Flutter

Siga a documentação oficial:

https://docs.flutter.dev/get-started/install/windows

Depois de instalar, verifique:

```powershell
flutter --version
dart --version
```

### 3. Verificar o ambiente

Execute:

```powershell
flutter doctor
```

O comando mostra quais componentes ainda precisam ser configurados.

Para desenvolvimento Android, normalmente será necessário configurar o Android Studio e um dispositivo/emulador Android.

---

## macOS

### 1. Instalar Git

Caso utilize Homebrew:

```bash
brew install git
```

### 2. Instalar Flutter

Siga:

https://docs.flutter.dev/get-started/install/macos

Verifique:

```bash
flutter --version
dart --version
```

### 3. Verificar o ambiente

```bash
flutter doctor
```

Para desenvolvimento iOS, é necessário utilizar o Xcode.

---

## Linux

### 1. Instalar dependências básicas

Em distribuições baseadas em Debian/Ubuntu:

```bash
sudo apt update
sudo apt install git curl unzip xz-utils zip libglu1-mesa
```

### 2. Instalar Flutter

Siga:

https://docs.flutter.dev/get-started/install/linux

Adicione o Flutter ao `PATH` conforme a documentação.

Verifique:

```bash
flutter --version
dart --version
```

### 3. Verificar o ambiente

```bash
flutter doctor
```

---

# Configurando o projeto

Depois de preparar o ambiente, clone o repositório:

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

---

# Executando o projeto

Verifique os dispositivos disponíveis:

```bash
flutter devices
```

Para executar o aplicativo:

```bash
flutter run
```

Caso existam vários dispositivos, você pode especificar qual utilizar:

```bash
flutter run -d <device-id>
```

Por exemplo:

```bash
flutter run -d emulator-5554
```

---

# Testes

Execute todos os testes automatizados:

```bash
flutter test
```

Para obter uma saída mais detalhada:

```bash
flutter test -r expanded
```

---

# Análise do código

Antes de enviar alterações, execute:

```bash
flutter analyze
```

O projeto deve estar sem erros de análise.

---

# Formatação

Para formatar o código:

```bash
dart format .
```

Para apenas verificar se os arquivos estão formatados corretamente:

```bash
dart format --set-exit-if-changed .
```

---

# Validação antes do commit

Recomenda-se executar os seguintes comandos antes de criar um commit:

```bash
flutter pub get
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

Todos devem terminar com sucesso.

---

# Estrutura do projeto

```text
securedelivery-mobile/
│
├── lib/
│   ├── app/
│   ├── presentation/
│   ├── monitoring/
│   ├── sensors/
│   ├── events/
│   ├── telemetry/
│   ├── navigation/
│   ├── storage/
│   ├── sync/
│   ├── device/
│   ├── network/
│   ├── security/
│   ├── core/
│   └── main.dart
│
├── test/
│   ├── events/
│   ├── monitoring/
│   ├── telemetry/
│   ├── navigation/
│   └── sync/
│
├── assets/
├── pubspec.yaml
└── README.md
```

### `lib/`

Contém o código principal do aplicativo.

### `test/`

Contém os testes automatizados.

### `assets/`

Contém recursos utilizados pelo aplicativo.

### `pubspec.yaml`

Define as dependências e configurações do projeto Flutter.

---

# Desenvolvimento

O projeto utiliza uma arquitetura modular para separar responsabilidades.

As integrações com sensores e recursos específicos da plataforma devem ser mantidas atrás de abstrações sempre que possível.

As principais áreas do aplicativo incluem:

* Monitoramento
* Sensores
* GPS
* Detecção de eventos
* Telemetria
* Navegação
* Armazenamento local
* Sincronização
* Comunicação com o backend
* Segurança
* Ativação do dispositivo

---

# Limpeza do projeto

Caso seja necessário limpar os arquivos gerados pelo Flutter:

```bash
flutter clean
```

Depois reinstale as dependências:

```bash
flutter pub get
```

E execute novamente:

```bash
flutter run
```

---

# Comandos principais

| Comando           | Descrição                      |
| ----------------- | ------------------------------ |
| `flutter pub get` | Instala as dependências        |
| `flutter run`     | Executa o aplicativo           |
| `flutter devices` | Lista dispositivos disponíveis |
| `flutter test`    | Executa os testes              |
| `flutter analyze` | Analisa o código               |
| `dart format .`   | Formata o código               |
| `flutter doctor`  | Verifica o ambiente            |
| `flutter clean`   | Limpa arquivos gerados         |

---

# Fluxo básico para um novo desenvolvedor

Depois de clonar o projeto:

```bash
cd securedelivery-mobile
flutter pub get
flutter doctor
flutter devices
flutter analyze
flutter test
flutter run
```

Depois disso, o ambiente local estará preparado para desenvolvimento.

---

## Status

**SecureDelivery Mobile — MVP em desenvolvimento.**
