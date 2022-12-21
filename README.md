# ansible_rol_netbox

Playbook para automatizar la carga de datos en NetBox via Ansible.

Testeado con docker + vagrant + libvirt.

---

scripts:

- netbox_install.sh

---

roles:

- grupos_sitios
- inquilinos
- regiones
- sitios
- locaciones
- racks

