Use apply script:

```sh
curl https://raw.githubusercontent.com/rbi13/env/master/apply.sh | sh
```

which will perform the following:

##aliases
```sh
echo "source ~/env/aliases" >> ~/.bashrc
```

##hosts
```sh
sudo cp ~/env/hosts /etc/hosts
```
