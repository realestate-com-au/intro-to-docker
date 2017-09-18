FROM microsoft/dotnet:1.0-sdk

ADD src/Worker /code/src/Worker

WORKDIR /code/src/Worker

RUN dotnet restore -v minimal
RUN dotnet publish -c Release

CMD dotnet /code/src/Worker/bin/Release/netcoreapp1.0/Worker.dll
