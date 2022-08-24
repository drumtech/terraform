#!/bin/bash
useradd --shell /bin/bash --home-dir /home/userok userok && echo userok:Password123 | chpasswd
