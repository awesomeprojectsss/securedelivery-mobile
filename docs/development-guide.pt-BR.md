# Guia de Desenvolvimento — SecureDelivery Mobile

## Objetivo

Este documento orienta o desenvolvimento do aplicativo Flutter que funciona como o device IoT principal do MVP.

Antes de desenvolver, leia:

1. `../docs/project.md`
2. `AGENTS.md`
3. `docs/architecture.md`
4. ADRs relevantes em `docs/decisions/`
5. `docs/git-workflow.pt-BR.md`

## Stack oficial

- Flutter
- Dart

Ainda serão escolhidos por ADR quando necessário:

- gerenciamento de estado;
- banco local;
- bibliotecas de sensores;
- background execution;
- secure storage;
- networking;
- injeção de dependência.

## Responsabilidade do mobile

O mobile não é apenas interface.

Ele deve:

- coletar sensores;
- coletar GPS;
- monitorar bateria/conectividade;
- detectar eventos localmente;
- persistir dados localmente;
- criar batches;
- executar store-and-forward;
- fazer retry;
- preservar evidências;
- sincronizar com o servidor.

## Regra arquitetural central

Nunca acople diretamente:

```text
callback do sensor -> request HTTP
```

Mantenha o pipeline:

```text
Sensores
  -> Coletor
  -> Detecção de eventos
  -> Persistência local
  -> Batch / Sync Engine
  -> API
```

Isso garante funcionamento mesmo sem internet.

## Flutter

### Widgets

Widgets devem cuidar principalmente de apresentação e interação.

Evite colocar:

- cálculos de sensor;
- regra de detecção;
- SQL/banco;
- retry;
- chamadas diretas a plugins;

dentro de widgets.

### Dart

- Use null safety.
- Evite `dynamic`.
- Prefira modelos imutáveis.
- Use tipos explícitos.
- Mantenha transições de estado claras.
- Evite casts apenas para calar o compilador.

### Plugins

Plugins de sensor, GPS, storage e plataforma devem ficar atrás de abstrações.

Isso permite testar o núcleo sem hardware real.

## Sensores

O MVP parte da premissa de celular fixado horizontalmente na caixa de entrega, atuando como o Device.

A orientação inicial deve ser tratada como calibração explícita.

Evite valores mágicos espalhados.

Centralize:

- thresholds;
- janelas de leitura;
- parâmetros de impacto;
- parâmetros de inclinação;
- parâmetros de queda.

## Frequência

A IMU precisa enxergar fenômenos rápidos, mas isso não significa enviar tudo ao servidor.

Baseline inicial:

```text
IMU bruta:                    50 Hz (~20 ms)
detecção:                     alta frequência/local
GPS / ground speed:           até 1 Hz
telemetria normal no Server:  resumo de 1 minuto
batch de rede:                normalmente 1 minuto
evidência de evento:          alta frequência
```

Fluxo:

```text
IMU 50 Hz                  GPS/velocidade até 1 Hz
   │                               │
   └──── processamento local ──────┘
                 │
         detector + buffers
                 │
       resumo operacional 1 min
                 │
           persistência local
                 │
              Server
```

Não envie 50 requests/s e não grave continuamente toda a IMU no servidor.

Ao detectar evento, preserve aproximadamente:

```text
2 s antes + evento + 2 s depois
```

Os valores devem ser configuráveis e calibrados em testes reais.

O timestamp real das leituras e eventos é obrigatório.

## Velocidade e KPIs de navegação

Velocidade faz parte do MVP.

Fonte preferencial:

```text
GNSS / ground speed fornecido pelo sistema operacional
```

Não calcule velocidade normal integrando acelerômetro, devido ao drift acumulado.

A cada minuto o Device deve gerar os agregados:

```text
navigation.distanceTraveledMeters
navigation.movingDurationSeconds
navigation.stoppedDurationSeconds
navigation.maximumSpeedMetersPerSecond
```

Unidades canônicas:

```text
distância -> m
tempo     -> s
velocidade -> m/s
```

O backend calcula a velocidade média em movimento por:

```text
distância total / tempo total em movimento
```

Não faça média simples das médias por minuto.

Threshold inicial para classificar movimento:

```text
1.5 m/s (~5.4 km/h)
```

Deve permanecer configurável.

Para eventos de movimento, quando o GPS estiver confiável, guarde contexto:

```text
navigation.speed.at_event
navigation.speed.average_5s_before
navigation.speed.maximum_10s_before
navigation.moving
```

Se a qualidade do GPS não for suficiente, não invente a velocidade.

Esses dados servem para correlação, não para afirmar automaticamente causalidade.

## Eventos

Eventos iniciais:

```text
motion.strong_impact
motion.critical_inclination
motion.possible_fall
motion.abnormal_movement
```

Cada evento deve guardar evidência suficiente para auditoria.

Exemplo:

- leituras de acelerômetro;
- giroscópio;
- valores calculados;
- localização;
- timestamps.

## Contrato extensível do Device

O Mobile não deve pedir alteração no backend para cada sensor novo.

Sensores usam:

```json
{
  "key": "motion.orientation.pitch",
  "value": 42.7,
  "unit": "deg"
}
```

Eventos usam `eventType` aberto, por exemplo:

```text
motion.critical_inclination
```

Todo evento deve informar detector e versão.

O Mobile é dono de:

```text
sensor -> processamento -> detecção -> evento -> evidência
```

Antes de alterar payloads, consulte `docs/contracts/` na raiz do workspace.

## Persistência local

Telemetria/eventos não sincronizados precisam sobreviver a:

- falta de internet;
- restart;
- falha de request;
- encerramento do app, quando a plataforma permitir persistência.

Não use somente memória.

Nunca remova dados apenas porque tentou enviar.

Remova/marque como sincronizado somente após confirmação válida do servidor.

## Idempotência

Crie IDs estáveis antes de transmitir:

- `batchId`
- `eventId`

Retry do mesmo conteúdo deve usar o mesmo ID.

## Background

Background é uma área crítica.

Sempre considerar:

- restrições do Android;
- restrições do iOS;
- permissões;
- economia de bateria;
- foreground service quando aplicável;
- suspensão do processo.

Não prometa comportamento que a plataforma não garante.

Documente limitações.

## Bateria

O monitoramento deve ser eficiente.

Evite:

- GPS excessivamente frequente;
- retry agressivo;
- reconstruções de UI por sensor;
- processamento desnecessário em background.

## Testes

Priorize código de detecção em Dart puro.

Teste com sequências sintéticas ou gravadas.

Cobrir:

- ângulo normal;
- inclinação crítica;
- impacto;
- queda simulada;
- falso positivo;
- IDs em retry;
- store-and-forward;
- reconnect;
- preservação das evidências.

Use fakes/mocks para plugins.

## Segurança

Credenciais devem usar storage seguro definido pela arquitetura.

Nunca:

- salvar token em texto puro;
- logar tokens;
- hardcodar secrets;
- confiar apenas em identificador físico do telefone.

## Dependências

Antes de adicionar pacote Flutter:

- validar manutenção;
- compatibilidade Android/iOS;
- licença;
- permissões;
- impacto em background;
- atividade recente;
- necessidade real.

Mudanças arquiteturais devem gerar ADR.

## Antes de abrir PR

Execute os comandos reais disponíveis no projeto, normalmente incluindo:

```bash
flutter pub get
dart format .
flutter analyze
flutter test
```

Se o projeto possuir outros checks, execute-os também.

Não considere a tarefa pronta se análise ou testes relevantes estiverem falhando.

Consulte `docs/git-workflow.pt-BR.md`.
