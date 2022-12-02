@rem build container
docker build --rm^
    -t wine-ubuntu:18.04 ^
    .

@rem execute developer mode
docker run -ti --rm -v %cd%\..\..\..\app:/app -w "/app" wine-ubuntu:18.04 bash -c "wine cmd"
