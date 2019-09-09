
## Reference

https://gist.github.com/reavon/0bbe99150810baa5623e5f601aa93afc

## Howto

To find: 
- dconf dump /org/gnome/terminal/legacy/profiles:/

To export: 
- dconf dump /org/gnome/terminal/legacy/profiles:/:1430663d-083b-4737-a7f5-8378cc8226d1/ > material-theme-profile.dconf

To import:
- dconf load /org/gnome/terminal/legacy/profiles:/:1430663d-083b-4737-a7f5-8378cc8226d1/ < material-theme-profile.dconf


