# pywb

Nový věk zpřístupnění českého webového archivu.

## Odkazy

[Zpřístupnění sklizní z roku 2023 kurátorům pomocí pywb](https://github.com/orgs/WebarchivCZ/projects/2)
[Webarchiv.cz dokumentace Pywb](https://webarchivcz.github.io/pywb/)

## Lokální vývoj

- `./local-pywb.sh` vytvoří ve složce `./local-pywb` sadu skriptů pro práci s pywb
- `./local-collection` - očekává sklizeň Topics-2023-07-T-APVVM
- `./local-pywb/run-local.sh` - spustí pywb v Docker kontejneru
  - [http://localhost:443/](http://localhost:443/) -> Pywb
  - [http://localhost:80/](http://localhost:80/) -> Traefik Dashboard
