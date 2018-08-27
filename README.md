# pcxchg
HLF course project

## Setup
1. Avvia il network con `docker-compose`.
1. Prepara la blockchain con `setup.sh`.

## Comandi utili
* `docker-compose -f docker-compose-pcxchg.yaml up`: avvia il network.
* `docker-compose -f docker-compose-pcxchg.yaml down`: arresta il network.
* `docker exec cli.HP bash -c 'peer chaincode query -C hp -n producer -c '\''{"Args":["queryCompleteStock"]}'\'''`: esegue un chaincode di query.
