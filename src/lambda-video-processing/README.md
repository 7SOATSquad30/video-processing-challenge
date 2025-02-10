# AWS Lambda para Processamento de Vídeos com Extração de Frames

Esta AWS Lambda tem como objetivo automatizar o processamento de arquivos de vídeo enviados para um bucket S3. A função é acionada por eventos provenientes de uma fila Amazon SQS, realiza o download do arquivo, extrai frames utilizando FFmpeg e disponibiliza os resultados em formato ZIP no S3 de saída.

---

## 🔧 Funcionalidades

- **Processamento automatizado de vídeos:**  
  A função recebe eventos do SQS contendo informações do vídeo a ser processado.  
- **Extração de frames com FFmpeg:**  
  Cada vídeo enviado é processado para gerar imagens frame a frame.  
- **Compactação dos frames em ZIP:**  
  Os frames extraídos são compactados para facilitar o armazenamento e compartilhamento.  
- **Upload para S3:**  
  O arquivo ZIP finalizado é enviado para o bucket S3 de saída.  
- **Atualização de status em DynamoDB:**  
  Registra o status de processamento do arquivo no DynamoDB.  
- **Notificação por e-mail:**  
  Tanto em caso de sucesso quanto de falha, um e-mail de notificação é enviado via Amazon SES.

---

## Fluxograma

```mermaid
graph TD
    A[Recebe evento do SQS] --> B[Atualiza status no DynamoDB para PROCESSANDO]
    B --> C[Baixa arquivo do S3]
    C --> D[Extrai frames com FFmpeg]
    D --> E[Cria arquivo ZIP com frames]
    E --> F[Faz upload do ZIP para o S3 de saída]
    F --> G[Atualiza status no DynamoDB para SUCESSO]
    G --> H[Solicita o link de download]
    H --> I[Retorna resposta com link de download]

    %% Tratamento de erros
    A -->|Chave ausente| X1[Chave ausente no evento]
    A -->|Erro JSON| X2[Erro ao decodificar JSON]
    A -->|Erro inesperado| X3[Erro inesperado]

    X1 --> Y1[Envia e-mail de erro]
    X2 --> Y2[Envia e-mail de erro]
    X3 --> Y3[Envia e-mail de erro]

    X1 --> Z[Retorna erro 500]
    X2 --> Z[Retorna erro 500]
    X3 --> Z[Retorna erro 500]
```

---

## ⚙️ Fluxo de Processamento

1. **Recebimento do evento do SQS:**  
   - A função é acionada quando uma nova mensagem chega na fila SQS.  
   - A mensagem contém o nome do bucket, a chave do arquivo de vídeo e informações do usuário.

2. **Atualização do status no DynamoDB:**  
   - O status do arquivo é atualizado para "PROCESSANDO".

3. **Download do arquivo do S3:**  
   - O vídeo é baixado para o diretório temporário da Lambda (`/tmp`).

4. **Extração de frames com FFmpeg:**  
   - Os frames do vídeo são extraídos e armazenados temporariamente.

5. **Criação do arquivo ZIP:**  
   - Todos os frames são compactados em um único arquivo ZIP.

6. **Upload do arquivo ZIP para S3:**  
   - O arquivo ZIP é carregado no bucket de saída.

7. **Geração de URL pré-assinada:**  
   - Uma URL pré-assinada é gerada para facilitar o download do arquivo pelo cliente.

8. **Envio de notificação por e-mail:**  
   - Um e-mail contendo o link de download é enviado ao cliente.

9. **Atualização do status para "SUCESSO":**  
   - O status final é atualizado no DynamoDB.

10. **Resposta de sucesso:**  
   - A Lambda retorna uma resposta indicando o sucesso do processamento.

---

## 🛡️ Tratamento de Erros

Caso ocorra algum problema durante o processamento, a função captura exceções e executa as seguintes ações:

- **Erros de chave ausente no evento SQS:**  
  - Atualiza o status para "ERRO", envia um e-mail de alerta e retorna erro 500.

- **Erro ao processar JSON da mensagem:**  
  - Atualiza o status para "ERRO", notifica por e-mail e retorna erro 500.

- **Falhas inesperadas:**  
  - Atualiza o status para "ERRO", notifica via e-mail e encerra o processamento com erro.

---

## 🪒 Tecnologias Utilizadas

- **AWS Lambda** – Processamento serverless do vídeo.  
- **Amazon SQS** – Fila de mensagens para acionar o processamento.  
- **Amazon S3** – Armazenamento de vídeos de entrada e saída.  
- **Amazon DynamoDB** – Rastreamento do status do processamento.  
- **Amazon SES** – Envio de notificações de erro e sucesso.  
- **FFmpeg** – Extração de frames dos vídeos.  
- **Python** – Linguagem utilizada na implementação.

---

## 🛂 Implantação

Para implantar esta função Lambda, siga as etapas abaixo:

1. Instale as dependências listadas no `requirements.txt`:  
   ```bash
   pip install -r requirements.txt -t package/
   ```

