#!/bin/bash


sed -rn "
:a;
N;
\$!ba;
s/#  -o smtpd_sasl_auth_enable=yes\s*\n)/\1/p
" /etc/postfix/master.cf






