# Rozpracované

## Květen 2024

- Automatická Indexace: `/mnt/archive/23/topics/Topics-2023-07-T-APVVM`
- Index: `/mnt/prase`
- Struktura

```Dockerfile
pywb:
    image: webrecorder/pywb:2.7.4
    volumes:
      # INDEX
      - "/mnt/prase:/webarchive/collections/topics/indexes/"
      # ARCHIV
      - /mnt/archive/23/topics/Topics-2023-07-T-APVVM:/webarchive/collections/topics/archive/23/Topics-2023-07-T-APVVM
      - /mnt/archive/23/topics/Topics-2023-08-T-MilanKundera:/webarchive/collections/topics/archive/23/Topics-2023-08-T-MilanKundera
      # KONFIGURACE
      - "{{ pywb_dir }}/config.yaml:/webarchive/config.yaml"
```

### Struktura pro Pywb

> Otázka jestli do téhle struktury zapadají i historická data. Je potřeba projít strukturu archivu od roku 2005.

```
Collections

- Topic 1 // Tématická sklizeň
    - Archive
        - Sklizeň 1
        - Sklizeň 2
        - Sklizeň 3
    - Indexes
        - Sklizeň 1
        - Sklizeň 2
        - Sklizeň 3

- Topic 2 // Tématická sklizeň
```

Index fyzický struktura

```
- /mnt/index
    - /topics
        - /Topics-2023-07-T-APVVM
        - /Topics-2023-08-T-MilanKundera
    - /totals
        - /2023
        - /2024

```

Mapování v Docker-compose

"fyzická casta na serveru":"cesta z pohledu pywb"

```Dockerfile
      - /mnt/archive/22/serials:/webarchive/collections/serials/archive/
      - /mnt/archive/22/totals:/webarchive/collections/totals/archive/
      - /mnt/archive/23/serials:/webarchive/collections/serials/archive/
      - /mnt/archive/23/totals:/webarchive/collections/totals/archive/
```

## Duben 2024

[Github commit](https://github.com/WebarchivCZ/pywb/commit/bdf54dc3b2ec8d3dc85e5e0d67a8dbcbb12f302e)

Ruční sklizeň - Facebook podmínky služby

docker-compose konfigurace

```Dockerfile
    pywb:
    image: webrecorder/pywb:2.7.4
    volumes:

      - "{{ pywb_dir }}/config.yaml:/webarchive/config.yaml"
      - "/mnt/archive/23/manuals/crawls/collections/:/webarchive/collections/"
```

[Pywb UI](http://10.3.0.21:443/all/20220628154342/https://www.facebook.com/legal/terms)

API Call `curl -s '10.3.0.21:443/all/cdx?url=www.facebook.com/legal/terms&output=json'` vrací

```json
{
  "urlkey": "com,facebook)/legal/terms",
  "timestamp": "20221209191852",
  "url": "https://www.facebook.com/legal/terms",
  "mime": "text/html",
  "status": "200",
  "digest": "GRUWGB5ZAMAPKEAC2DOOD2AEY7M6P2EZ",
  "length": "290673",
  "offset": "496164353",
  "filename": "rec-20221209182111914788-65f062a0d7a3.warc.gz",
  "source": "1222_prezident23/indexes/index.cdxj",
  "source-coll": "1222_prezident23",
  "access": "allow"
}
```
