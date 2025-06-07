# Multi Downloader (versão mobile) 📥

<div align="center">

![Badge em Desenvolvimento](http://img.shields.io/static/v1?label=STATUS&message=FINALIZADO&color=GREEN&style=for-the-badge) <!--[![](http://img.shields.io/static/v1?label=BAIXAR&message=EXECUTÁVEL&color=blue&style=for-the-badge)](https://www.mediafire.com/file/np5zvv0hqqjdmgh/Multi-Downloader.rar/file) -->

</div>

Bem-vindo ao **Multi Downloader Mobile**! Este projeto é uma aplicação gráfica que permite baixar vídeos de várias plataformas populares, como YouTube, Instagram, Twitter e Facebook, utilizando o framework `Flutter` para a interface gráfica.

---


## 🧱 Estrutura do Projeto

```plaintext
multi_downloader/
├── backend/                  ← FastAPI (Python)
│   ├── app/
│   │   ├── __init__.py
│   │   ├── main.py           ← Roteador FastAPI
│   │   └── downloader.py     ← Lógica do download
│   ├── downloads/            ← Armazenamento temporário
│   └── requirements.txt
├── frontend/                 ← App Flutter
│   ├── multi_downloader_mobile
│       ├── ...outros arquivos...
│       ├── lib
│       │   ├── main.dart
│       │   └── splash.screen.dart
        └── ...outros arquivos...
```

---

## Funcionalidades 🚀

- **Download de vídeos do YouTube** 🎥
- **Download de posts do Instagram** 📸
- **Download de vídeos do Twitter** 🐦
- **Download de vídeos do Facebook** 📘
- **Todos em formato de áudio ou vídeo**

---

## Como Usar 🛠️

**Observações:** Ao executar o programa, inserir a URL e fazer o download do vídeo, será criada automaticamente uma subpasta no diretório raiz onde se encontra o aplicativo, de acordo com a origem: `downloads-Youtube` para vídeos do Youtube, `downloads-Instagram` para vídeos do Instagram, `downloads-Twitter` para vídeos do Twitter e `downloads-Facebook` para vídeos do Facebook.

---

## Interface Gráfica 🖥️

A interface gráfica é construída utilizando [Flutter](https://flutter.dev/) e possui os seguintes componentes:

- **Campo de entrada para URL**: Insira a URL do vídeo que deseja baixar.
- **Select do Formato**: Escolha entre áudio(.mp3) ou vídeo (.mp4).
- **Botão de Download**: Inicia o download do vídeo/post.
- **Barra de Progresso**: Mostra o progresso do download.

---

## Dependências 📦

- [fastapi](https://fastapi.tiangolo.com/): Estrutura da Web moderna e rápida para criar APIs com Python.
- [yt_dlp](https://github.com/yt-dlp/yt-dlp): Biblioteca para download de vídeos do YouTube e de outras redes sociais.
- [dio](https://pub.dev/packages/dio): Pacote de rede HTTP, suporta configuração global, upload/download de arquivos, adaptadores personalizados.
- [path_provider](https://pub.dev/packages/path_provider): Plugin para encontrar locais comumente usados no sistema de arquivos.
- [open_file](https://pub.dev/packages/open_file): Plugin que pode chamar o APP nativo para abrir arquivos com string resulta em vibração.
- [flutter_native_splash](https://pub.dev/packages/flutter_native_splash): Gera automaticamente código para personalizar a cor de fundo da tela inicial nativa e a imagem inicial.
- [http](https://pub.dev/packages/http): Uma biblioteca combinável baseada no Future para fazer solicitações HTTP.
- [google_fonts](https://pub.dev/packages/google_fonts): Um pacote Flutter para usar fontes de fonts.google.com.

---


## Contribuição 🤝

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues e pull requests.

---

## Licença 📄

Este projeto está licenciado sob a MIT License.

---

Feito no fim de semana por [Wilson Souza](https://github.com/wilsondesouza)
