



    name: Send Email with SendGrid

    on: [push]

    jobs:
      send_email:
        runs-on: ubuntu-latest
        steps:
          - name: SendGrid Email
            uses: peter-evans/sendgrid-action@v1
            env:
              SENDGRID_API_KEY: ${{ secrets.SENDGRID_API_KEY }}
            with:
              to: 'recipient@example.com'
              from: 'sender@example.com'
              subject: 'GitHub Action Email'
              text: 'This email was sent from a GitHub Action using SendGrid.'



    - name: Log in to Azure Container Registry
      uses: docker/login-action@v2
      with:
        registry: myregistry.azurecr.io # Replace with your ACR login server
        username: ${{ secrets.ACR_USERNAME }} # Store ACR username as a secret
        password: ${{ secrets.ACR_PASSWORD }} # Store ACR password or Service Principal password as a secret





- name: Get the tag name
  id: get_version
  run: echo "VERSION=${GITHUB_REF#refs/tags/}" >> $GITHUB_OUTPUT

- name: Build and Push the Docker Image
  uses: docker/build-push-action@v6
  with:
    context: .
    file: ./Dockerfile
    push: true
    tags: |
      ${{ env.DOCKER_REGISTRY }}/${{ env.DOCKER_IMAGE_NAME }}:${{ steps.get_version.outputs.VERSION }}
      ${{ env.DOCKER_REGISTRY }}/${{ env.DOCKER_IMAGE_NAME }}:latest
    cache-from: type=registry,ref=${{ env.DOCKER_REGISTRY }}/${{ env.DOCKER_IMAGE_NAME }}:buildcache
    cache-to: type=registry,ref=${{ env.DOCKER_REGISTRY }}/${{ env.DOCKER_IMAGE_NAME }}:buildcache,mode=max




    deploy:
    needs: build
    name: Deploy image on OCI compute instance
    runs-on: ubuntu-latest

    steps:
    - name: install ssh keys
      run: |
          install -m 600 -D /dev/null ~/.ssh/id_rsa
          echo "${{ secrets.SSH_PRIVATE_KEY }}" > ~/.ssh/id_rsa
          ssh-keyscan -H ${{ secrets.SSH_HOST }} > ~/.ssh/known_hosts
    - name: connect and pull
      run: ssh ubuntu@${{ secrets.SSH_HOST }} "cd ${{ secrets.WORK_DIR }} && sudo docker  compose pull && sudo docker compose up app -d && exit"
    - name: cleanup
      run: rm -rf ~/.ssh


- name: Log in to Azure Container Registry
      uses: docker/login-action@v2
      with:
        registry: myregistry.azurecr.io # Replace with your ACR login server
        username: ${{ secrets.ACR_USERNAME }} # Store ACR username as a secret
        password: ${{ secrets.ACR_PASSWORD }} # Store ACR password or Service Principal password as a secret



docker rm -f ${{ env.DOCKER_REGISTRY }}/${{ env.DOCKER_IMAGE_NAME }}:${{ steps.get_version.outputs.VERSION }}
docker rmi ${{ env.DOCKER_REGISTRY }}/${{ env.DOCKER_IMAGE_NAME }}:*
docker run -it -p ${{DOCKER_OUT_PORT}}:${{DOCKER_INNER_PORT}} --restart always --name {{DOCKER_CONTAINER_NAME}} ${{ env.DOCKER_REGISTRY }}/${{ env.DOCKER_IMAGE_NAME }}:${{ steps.get_version.outputs.VERSION }}
exit


DOCKER_CONTAINER_NAME
DOCKER_IMAGE_NAME
DOCKER_INNER_PORT
DOCKER_OUT_PORT







  deploy:
    needs: build-and-push
    runs-on: ubuntu-latest
    steps:
    - name: Deploy to remote host
      uses: appleboy/ssh-action@master
      with:
        host: ${{ secrets.SSH_HOST_IP }}
        username: ${{ secrets.SSH_USER }}
        password: ${{ secrets.SSH_PASSWORD }}
        script: |
          echo "${{ secrets.ACR_PASSWORD }}" | docker login -u "${{ secrets.ACR_USERNAME }}" --password-stdin ${{ secrets.ACR_REGISTER }}
          
          if [ "$(docker ps -a -q -f name="${{ env.DOCKER_CONTAINER_NAME }}")" ]; then

            docker rm -f ${{ env.DOCKER_REGISTRY }}/${{ env.DOCKER_IMAGE_NAME }}:${{ steps.get_version.outputs.VERSION }}
            docker rmi ${{ env.DOCKER_REGISTRY }}/${{ env.DOCKER_IMAGE_NAME }}:*
          fi

          docker run -it -d -p 8080:8000 --restart=always --name${{ env.DOCKER_CONTAINER_NAME }}    ${{secrets.ACR_REGISTER}}/${{ env.DOCKER_IMAGE_NAME }}:${{ github.sha }}
