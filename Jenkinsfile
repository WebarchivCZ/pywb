pipeline {
  agent any
    stages {
      stage('Deploy to test') {
        when {
          anyOf { branch 'main'; branch 'production'; branch 'feature/*' }
        }
        environment {
                SSH_CREDS = credentials('ansible')
        }
        steps {
          sh '''#!/usr/bin/env bash
            # Make Bash Great Again
            set -o errexit # exit when a command fails.
            set -o nounset # exit when using undeclared variables
            set -o pipefail # catch non-zero exit code in pipes
            # set -o xtrace # uncomment for bug hunting

            cd ci
            ansible-playbook -i test --private-key ${SSH_CREDS} -u ${SSH_CREDS_USR} deploy.yaml
          '''
        }
      }
      stage('Deploy to production & run pywb') {
        when {
          anyOf { branch 'production'}
        }
        environment {
                SSH_CREDS = credentials('ansible')
        }
        steps {
          input "Přísáhám před krutým a přísným bohem, že https://test.pywb.webarchiv.cz/wayback je v perfektním stavu a stvrzuji, že může jít do produkce na https://pywb.webarchiv.cz/wayback."
          sh '''#!/usr/bin/env bash
            # Make Bash Great Again
            set -o errexit # exit when a command fails.
            set -o nounset # exit when using undeclared variables
            set -o pipefail # catch non-zero exit code in pipes
            # set -o xtrace # uncomment for bug hunting

            cd ci
            ansible-playbook -i prod --private-key ${SSH_CREDS} -u ${SSH_CREDS_USR} deploy.yaml
          '''
        }
      }
    }
}
