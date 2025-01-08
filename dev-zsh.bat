@rem execute developer mode
docker build -t zsh %cd%\conf\docker\zsh
docker run -ti --rm -v %cd%\app:/app -w "/app" zsh
