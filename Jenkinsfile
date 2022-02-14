podTemplate(yaml: """
apiVersion: v1
kind: Pod
metadata:
  labels:
    some-label: some-label-value
spec:
  containers:
  - name: jenkins-slave
    image: mshaibek/jenkins-slave-312
    command:
    - cat
    tty: true
    env:
    - name: DOCKER_HOST
      value: 'tcp://localhost:2375'
  - name: dind-daemon
    image: 'docker:18-dind'
    command:
    - dockerd-entrypoint.sh
    tty: true
    securityContext: 
      privileged: true 
"""
) {
    node(POD_LABEL) {
      properties([
        pipelineTriggers([
          [$class: 'GitHubPushTrigger'], // this means to trigger a build on github push action
          pollSCM('*/1 * * * *'), // poll every 1 minute
          ])
      ])
      checkout scm
      container('jenkins-slave') {
        sh ''' 
        ./deploy.sh
        '''
      }
    }
}