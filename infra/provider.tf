provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region     = "${var.aws_region}"
}

resource "aws_key_pair" "deployer" {
    key_name   = "deployer-key" 
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAyg2rSFYrpICLIWfT56knziPkYI8Omw0/Ie5pdTkV5JdrQvSzMPWuymvQa9/tdjBRt0La+xqBMMUDJm3GuHOTfnPlWZQJKrxKnYfd914+4rACmqQyWLCzZeSG4/s2YO/W1c7xOwWxMUY4HD+VqXOFwNR5oeEDYArYW4uJY3tdC10xGid0dE8Odcko0mTnLOIMpHGUB3RExdpE4gAgEGdhSX+A95nsXt3Xq4m7T0aGVxoB26yFipLUCPFv2h3i0JLwhY4RxuGtJdmPZA4zWFaYEfx81sWGZ6SVrNEes8P7hSHKYSn826CTCJc9Zc6q+uVbSFmNaPhzzYT2Arx1OuiU0w== zike@zike.local"
}