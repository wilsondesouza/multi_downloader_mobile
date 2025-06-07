from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from fastapi.responses import FileResponse
from app.downloader import download_media
import os

app = FastAPI()

class DownloadRequest(BaseModel):
    url: str
    formato: str  # 'mp3' ou 'mp4'

@app.post("/download/")
def process_download(request: DownloadRequest):
    if request.formato not in ['mp3', 'mp4']:
        raise HTTPException(status_code=400, detail="Formato inválido. Use 'mp3' ou 'mp4'.")

    try:
        filename = download_media(request.url, request.formato)
        return {
            "mensagem": "Arquivo baixado com sucesso!",
            "arquivo": filename,
            "link_download": f"/media/{filename}"
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/media/{filename}")
def serve_file(filename: str):
    filepath = os.path.join("downloads", filename)

    if not os.path.isfile(filepath):
        raise HTTPException(status_code=404, detail="Arquivo não encontrado.")

    media_type = "audio/mpeg" if filename.endswith(".mp3") else "video/mp4"
    return FileResponse(filepath, media_type=media_type, filename=filename)
