

1) 
    precisar
        host_do_container
        usuário
        senha
        nome da imagem
    fazer
        docker build 
        docker push


2) Docker pull
    precisar
        sshkey
        host_do_container
        usuário
        senha
        nome do container
        nome da imagem
        porta interna
        porta externa
    fazer
        docker rm -f
        docker rmi
        docker pull
        docker run
        