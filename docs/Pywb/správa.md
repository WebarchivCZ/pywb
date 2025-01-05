# Správa kolekcí

## Uživatelé pywb-test a pywb-prod

S archivem se interaguje skrze uživatele`pywb-test` a `pywb-prod`. Přihlášení probíhá skrve osobního uživatele a pak se použije `sudo su - pywb-test` nebo `sudo su - pywb-prod` k získání terminálu pywb. Existují jen produkční kolekce, v nich vytvořené indexi a z kolekcí směřují symbolické odkazy do úložiště. Samotný pywb běží v oddělených kontejnerech, takže je možné konfigurace testovat bez vlivu na produkční prostředí. Nicméně nástroje `./collection-manager` a `./cdxj-manager` pracují jen se sdílenou reprezentací data. Pokud by bylo k dispozici dost místa, je možné vytvořit `/mnt/index/collections-test` a připravit paralelní kolekce pro testování. Jelikož nástroj uchovává již vytvořené indexi v adresáři `/mnt/index/cdxj-archive/`, je možné přepoužít již hotové indexy v alternativních kolekcích.

## Tmux

Většina následujících nástrojů vytváří dlouhoběžící procesy. Proto je dobré používat [tmux](https://github.com/tmux/tmux). Ten umožňuje se odpojit od terminálu aniž by byli zabit dlouhodobý proces. A je možné se k terminálu s běžícím procesem opět kdykoliv připojit.

Vytvoření nového okna v `tmux`u

```shell
pywb-test@war2:~$ tmux
```

Odchod z Tmux terminálu bez ukončení běžících procesů.

```shell
pywb-test@war2:~$ ^b d
/// tedy zmáčknou CTRL+b a poté d.
```

Ukočení Tmux terminálu (všechny procesy v terminálu budou ukončeny).

```shell
pywb-test@war2:~$ exit
```

Přiojit se k Tmux terminálu

```shell
pywb-test@war2:~$ tmux attach
```

Práce s více tmux terminály

```shell
pywb-test@war2:~$ tmux ls
10: 1 windows (created Sat Jan  4 00:45:03 2025) (attached)
11: 1 windows (created Sun Jan  5 20:04:26 2025)
6: 1 windows (created Fri Jan  3 17:09:01 2025) (attached)
7: 1 windows (created Fri Jan  3 17:09:20 2025) (attached)
pywb-test@war2:~$ tmux a -t 11
```

## Spráce Kolekcí - ./collection-manager.sh

Slouží ke správě kolekcí. Každá kolekce umožní zobrazit pouze archivní data, které do ní patří. Pokud by byli všechny data jen v jedné kolekci, nebylo by například možné oddělit celoplošné sklizně od tématických sklizní při kontrole kvality sklizně.

V praxi nástroj hledá soubory `*.warc.gz|*.arc.gz` ve vybraném úložišti. A pomocí sady pravidel vytvoří kolekci pro dané archivy. V kolekci vytvoří složky `archive` a `indexes`. A do složky `archive` vytvoří symbolické odkazy vedoucí do úložiště. Tímto způsobem pywb okamžitě vidí nové kolekce. A jakmile dojde k vytvoření indexu dané kolekce, je možné procházet jak samotnou kolekci, tak použít souhrnou kolekci /wayback/, která zobrazí všechny kolekce.

Úložiště je po řadě incidentů fragmentováno i mimo obvyklou strukturu `/mnt/archiv/{05..25}`. Collection manager s touto situací umí pracovat. Pří zpracování roku úložiště má předkonfigurované cesty, kde se archivy nacházejí. P

```bash
case $param in
		13)
			ARCHIVE_YEAR=13
			SEARCH_ROOT_DIR=/mnt/datas/178/archive13
			;;
		14)
			ARCHIVE_YEAR=14
			SEARCH_ROOT_DIR="/mnt/datas/178/archive14 /mnt/datas/178/archive14 /mnt/datas/178/archive14Serials /mnt/datas/178/Archive14NDK-part /mnt/datas/180"
			;;
```

```shell
pywb-test@war2:~$ ./collection-manaager.sh 14
Processing Archive: 14. Mounted at /mnt/datas/178/archive14 /mnt/datas/178/archive14 /mnt/datas/178/archive14Serials /mnt/datas/178/Archive14NDK-part /mnt/datas/180. Time for coffer break.
```

Kolekce mají prefix ve formátu `YY`, ten odkazuje na rok úložitě. Prefix snižuje šanci na kolizi názvů kolekcí, ale možnost kolizce není zcela vyloučena. Je ale možné vytvořit kolekci bez prefixu, pokud se jedná například o tématickou sklizeň napříč roky. Jde ale spojit Prezidenské volby z různých let do jedné kolekce.

```shell
pywb-test@war2:/mnt/index/collections$ ls -1 *Serials* |grep Serials
05-Serials:
06-Serials:
07-Serials:
08-Serials:
09-Serials:
10-Serials:
```

Jedna kolekce může obsahovat více sklizní. Například všechny sklizně obsahující název Serials nebo serials, jsou uchovány v jedné kolekci Serials pro daný rok. Např. `/mnt/index/collections/05-Serials/archive/` obsahuje archivy ze sklizní `2005-12-24-serials`, `2004-05-00-serials` a `2005-06-12-serials` uložených v `/mnt/archive/05/`.

```shell
IAH-20051224150339-00009-harvester.nkp.cz.arc.gz -> /mnt/archive/05/serials/2005-12-24-serials/IAH-20051224150339-00009-harvester.nkp.cz.arc.gz
NEDLIB--20051117164000-00000.arc.gz -> /mnt/archive/05/serials/2004-05-00-serials/NEDLIB--20051117164000-00000.arc.gz
neuroacta-20050617160122-00001.arc.gz -> /mnt/archive/05/serials/2005-06-12-serials/neuroacta-20050617160122-00001.arc.gz
```

Všechny kolekce existují v adresáři `/mnt/index/collections`. Pywb umožňuje jen plochou strukturu kolekcí. Proto kolekce používají prefix roku, kde byl obsah archivován.
Příkad:

```shell
pywb-test@war2:/mnt/index/collections$ ls
05-cz         05-militaria-20041212  06-estonia   06-Serials     06-zive_servery    07-Serials
05-cz2004     05-Serials             06-harvest0  06-slovakia    07-cz2007          08-cz2008
05-cz2005     05-vysocina            06-idnes     06-slovenia    07-MICR
05-dalimil    06-cz2006              06-Ikaros    06-univerzity  07-novaBudovaNK
05-info_muni  06-czech               06-povodne   06-volby2006   07-olympiadaPraha

pywb-test@war2:/mnt/index/collections$ tree -d
.
├── 05-cz
│   ├── archive
│   └── indexes
├── 05-cz2004
│   ├── archive
│   └── indexes
├── 05-cz2005
│   ├── archive
│   └── indexes
├── 05-dalimil
│   ├── archive
│   └── indexes
├── 05-info_muni
│   ├── archive
│   └── indexes
├── 05-militaria-20041212
│   ├── archive
│   └── indexes
├── 05-Serials
│   ├── archive
│   └── indexes
├── 05-vysocina
│   ├── archive
│   └── indexes
...
```

### Použití Collection Manager

Uživatelé `pywb-test` a `pywb-prod` mají přístup k nástroji `collection-manager.sh` ze své domovské složky.

#### Vytvoření kolekce z úložiště

```shell
./collection-manaager.sh 24
```

#### Vytvoření kolekce z více úložišť

```shell
for archive in 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24; do ./collection-manaager.sh ${archive}; done
```

Výstup po vytváření kolekce.

```shell
pywb-test@war2:~$ for archive in 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24; do ./collection-manaager.sh ${archive}; done
Processing Year: 05
Processing Year: 06
Processing Year: 07
Processing Year: 08
Processing Year: 09
Processing Year: 10
Processing Year: 11
find: ‘/mnt/archive/11/.mmbackupCfg/prepFiles’: Permission denied
find: ‘/mnt/archive/11/.mmbackupCfg/expiredFiles’: Permission denied
find: ‘/mnt/archive/11/.mmbackupCfg/updatedFiles’: Permission denied
Processing Year: 12
Processing Year: 13
Processing Year: 14
Processing Year: 15
Processing Year: 16
Processing Year: 17
Processing Year: 18
Processing Year: 19
Processing Year: 20
Processing Year: 21
Processing Year: 22
Processing Year: 23
Processing Year: 24
pywb-test@war2:~$
```

## Indexační nástroj ./cdxj-manager.sh
Je wrapper nástroje [cdxj-indexer](https://github.com/webrecorder/cdxj-indexer/tree/main). Slouží k vytvoření indexu pro danou kolekci. Index je nutný pro zobrazení archivních dat. Indexování je časově náročný proces.

Nástroj nejdříve zkontroluje zda-li index pro daný archiv již neexistue v adresáři `/mnt/index/cdxj-archive/`. Pokud existuje, zkopíruje již existující index do kořene adresáře kolekce `/mnt/index/collections/{{collection}/`. Pokud index neexistuje, nástroj vytvoří index do kořene adresáře kolekce `/mnt/index/collections/{{collection}/`. Zda-li byl index vytvořen nebo zkopírován je zaznamenán do logu `/mnt/index/collections/{{collection}/${date -u --iso-8601}.log`.

V logu je možné zjistit živá data z probíhající indexace.

```shell
pywb-test@war2:/mnt/index/collections$ tail -f 05-cz/2025-01-05.log
[2025-01-05T20:29:11+00:00] Processing /mnt/index/collections/05-cz/archive/NEDLIB--20051122211225-00000.arc.gz into /mnt/index/collections/05-cz/NEDLIB--20051122211225-00000.arc.gz.cdxj
[2025-01-05T20:29:13+00:00] Processing /mnt/index/collections/05-cz/archive/NEDLIB--20051130094855-00000.arc.gz into /mnt/index/collections/05-cz/NEDLIB--20051130094855-00000.arc.gz.cdxj
[2025-01-05T20:29:15+00:00] Processing /mnt/index/collections/05-cz/archive/NEDLIB--20051209053122-00000.arc.gz into /mnt/index/collections/05-cz/NEDLIB--20051209053122-00000.arc.gz.cdxj
```

Jakmile jsou všechny indexy archivy v kolekci vytvořené. Nástroj setřídí všechny `*.arc.gz` a `*.warc.gz` do souboru `/mnt/index/collections/{{collection}/indexes/index.cdxj`. A poté přesune indexy do `/mnt/index/cdxj-archive/`.

Všechny chybové zprávy vzniklé při indexaci jsou uchovány `/mnt/index/cdxj-archive/logs/{ARCHIVE_NAME}.cdxj.stderr`.

### Indexace jedné kolekce

```shell
pywb-test@war2:~$ ./cdxj-manager.sh 05-cz
```

### Indexace více kolekcí

Indexace všech kolekcí z roku 05.

```shell
pywb-test@war2:~$ for collection in $(ls /mnt/index/collections/ |grep ^05-*); do ./cdxj-manager.sh $collection; done
[2025-01-05T20:14:38+00:00] Processing 05-cz
```

## Nástroje pywb

### Jak zjistit z jaké kolekce URL pochází?

MementoAPI poskytuje informace o URL. Výstup obsahuje informace o URL, kolekci, časové známce a kolekci.

```shell
pywb-test@war2:~$ curl http://10.3.0.21:443/wayback/timemap/link/http://underground.cz/814
<http://10.3.0.21:443/wayback/timemap/link/http://underground.cz/814>; rel="self"; type="application/link-format"; from="Sun, 14 Jul 2002 18:04:22 GMT",
<http://10.3.0.21:443/wayback/http://underground.cz/814>; rel="timegate",
<http://underground.cz/814>; rel="original",
<http://10.3.0.21:443/wayback/20020714180422mp_/http://underground.cz/814>; rel="memento"; datetime="Sun, 14 Jul 2002 18:04:22 GMT"; collection="05-cz"
```

### Získání metadata o URL pomocí cdx?

[Pywb UI](http://10.3.0.21:443/all/20220628154342/https://www.facebook.com/legal/terms)

```bash
pywb-test@war2 curl -s '10.3.0.21:443/wayback/cdx?url=www.facebook.com/legal/terms&output=json'
```

vrací

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

### Indexační nástroj ./wb-manager-reindex.sh

> [!WARNING]
> Tento nástroj je omezený počtem paměti serveru. Proto se nehodí na větší sklizně. S každým novým archivem v kolekci, stoupa spotřeba paměti. Nástroj ./cdxj-manager.sh by měl být spolehlivější..

Je wrapper nástroje pywb manager. Slouží k vytvoření indexu pro danou kolekci. Index je nutný pro zobrazení archivních dat. Indexování je časově náročný proces. Indexování je možné spustit pro jednu kolekci.

Wrapper spustí příklaz wb-manager reindex uvnitř kontejneru pywb. Příkaz vyžaduje název kolekce. Název kolekce je název složky v adresáři `/mnt/index/collections/`. Wrapper na konci indeakce vypíše dobu trvání indexace a všechny chyby uloží do složky `/home/{pywb-test|pywb-prod}/logs/`, dle uživatele, který nástroj spustil.

#### Indexace jedné kolekce

```shell
pywb-test@war2:~$ ./wb-manager-reindex.sh 05-cz
indexing collection: 05-cz

```

#### Indexace více kolekcí

```shell
pywb-test@war2:~$ for collection in /mnt/index/collections/{05,06,07,08,09,10,11,12}*; do ./wb-manager-reindex.sh $(basename ${collection}); done
indexing collection: 05-cz
```

Výstup seznamu nalazených kolekcí.

```shell
pywb-test@war2:~$ for collection in /mnt/index/collections/{05,06,07,08,09,10,11,12}*; do echo $(basename ${collection}); done
05-cz
05-cz2004
05-cz2005
05-dalimil
05-info_muni
05-militaria-20041212
05-Serials
05-vysocina
06-cz2006
06-czech
06-estonia
06-harvest0
06-idnes
06-Ikaros
06-povodne
06-Serials
06-slovakia
06-slovenia
06-univerzity
06-volby2006
06-zive_servery
07-cz2007
07-MICR
07-novaBudovaNK
07-olympiadaPraha
07-Serials
08-cz2008
08-novaBudovaNK
08-novaBudovaSTK
08-Serials
08-volba-prezident-2008
08-vyroci68
09-cz2009
09-evropskeVolby2009
09-komunismusIdnes
09-liberec
09-novaBudovaNK
09-novaBudovaSTK
09-predsednictviEU
09-selectedSites
09-selective
09-Serials
09-testing
10-cz2010
10-Serials
11-ArchiveIt
11-cz2011
11-Havel-2011
11-Serials
11-test_files
12-ArchiveIt
12-Bloguje-2012
12-Extras
12-Havel-2011
12-NKP-2012
12-Serials
12-testCrawls
```
