resource "aws_instance" "frontend" {
    connection {
        user = "ubuntu"
        key_file = "${var.key_path}"
    }

    ami = "${lookup(var.aws_amis, var.aws_region)}"
    instance_type = "t2.micro"

    availability_zone = "${lookup(var.aws_azs, count.index)}"

    subnet_id = "${aws_subnet.us-east-1a-public.id}"

    security_groups = [ "${aws_security_group.public_sg.id}" ]
    key_name = "${var.key_name}"
    tags { 
      Name = "frontend"
      AZ = "A"
      Ring = "Frontend"
    }

    # Move nginx config into place
    provisioner "file" {
        source = "files/default.nginx"
        destination = "/tmp/default"
    }

    provisioner "file" {
        source = "files/rbenv_install.sh"
        destination = "/tmp/rbenv_install.sh"
    }

    # Install softwares
    provisioner "remote-exec" {
        scripts = [ "files/install.sh" ]
    }

    # Run rbenv_install and restart nginx
    provisioner "remote-exec" {
        inline = [
            "sudo -H -u app bash -c 'git clone https://github.com/zajk/ontime_infra.git'",
            "sudo -H -u app bash -c 'cd ontime_infra; gem install bundler; bundle'",
            "sudo -H -u app bash -c 'cd ontime_infra; ruby injectmongo.rb'",
            "sudo cp /tmp/default /etc/nginx/sites-enabled/default",
            "sudo service nginx restart",
        ]
    }
    
}