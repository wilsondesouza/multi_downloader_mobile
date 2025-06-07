import os
import re
import unicodedata
from yt_dlp import YoutubeDL

def limpar_titulo(titulo: str, max_length=100) -> str:
    # Remove acentos e normaliza
    titulo = unicodedata.normalize("NFKD", titulo).encode("ASCII", "ignore").decode()
    
    # Remove emojis e caracteres especiais
    titulo = re.sub(r'[^\w\s-]', '', titulo)  # Remove tudo que não for letra, número, underline, espaço ou hífen
    titulo = re.sub(r'[\s_]+', '_', titulo)   # Substitui espaços por underlines
    titulo = titulo.strip('_')                # Remove underlines nas pontas
    
    # Limita tamanho
    return titulo[:max_length]

def download_media(url: str, formato: str) -> str:
    os.makedirs("downloads", exist_ok=True)

    # Extração dos metadados antes do download
    with YoutubeDL({'quiet': True}) as ydl:
        info = ydl.extract_info(url, download=False)
        titulo_original = info.get("title", "video")
        titulo_limpo = limpar_titulo(titulo_original)
        filename_base = titulo_limpo if titulo_limpo else "video"

    # Definir extensão
    extensao = "mp3" if formato == "mp3" else "mp4"
    outtmpl = f'downloads/{filename_base}.%(ext)s'

    # Configurações do yt_dlp
    if formato == 'mp3':
        ydl_opts = {
            'format': 'bestaudio/best',
            'outtmpl': outtmpl,
            'quiet': True,
            'postprocessors': [{
                'key': 'FFmpegExtractAudio',
                'preferredcodec': 'mp3',
                'preferredquality': '192',
            }],
        }
    else:  # mp4
        ydl_opts = {
            'format': 'bestvideo+bestaudio/best',
            'outtmpl': outtmpl,
            'quiet': True,
            'merge_output_format': 'mp4',
        }

    with YoutubeDL(ydl_opts) as ydl:
        info = ydl.extract_info(url, download=True)
        final_path = ydl.prepare_filename(info)

        # Ajustar a extensão correta
        if formato == 'mp3':
            final_path = os.path.splitext(final_path)[0] + '.mp3'
        elif formato == 'mp4':
            final_path = os.path.splitext(final_path)[0] + '.mp4'

        return os.path.basename(final_path)
