---
name: workspace-setup
description: >
  Configura el espacio de trabajo de zellij de un proyecto (dev.kdl + objetivos workspace/kill del Makefile) para el comando `work`.
  Trigger: Cuando se pide agregar un proyecto al comando `work`, crear o modificar un dev.kdl / layout de zellij, agregar un alias de proyecto, o tocar el objetivo `workspace` de un Makefile.
license: MIT
metadata:
  author: edoriban
  version: "1.0"
  scope: [root]
  auto_invoke:
    - "Agregar un proyecto al comando `work`"
    - "Crear o modificar un layout de zellij (dev.kdl)"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash
---

## Regla número uno

**`work` es una función de bash definida en `~/.bashrc` (línea ~148). NO es un script.**

Una función de shell siempre tapa a cualquier ejecutable del PATH. Crear
`~/.local/bin/work` es trabajo tirado a la basura: nunca se ejecutaría.

- **Nunca** crees un ejecutable llamado `work`.
- Para agregar un proyecto **no se toca el comando**: se le agrega un objetivo
  `workspace` al `Makefile` del proyecto.
- Lo único que se edita del `~/.bashrc` es el `case` de alias, y solo si el
  proyecto tiene nombre largo (ver más abajo).

La función, tal cual:

```bash
work() {
    local name="$1"
    case "$name" in
        vision) name="insytech-vision" ;;
        kitting) name="insytech-kitting" ;;
        mes) name="insytech-mes" ;;
        tempel) name="tempel-downtime-oee" ;;
        depot|vandepot) name="van-depot" ;;
        music|musictools) name="musictools" ;;
        af4|af4-bdnr|bdnr) name="af4-bdnr-leptos" ;;
    esac
    local dir
    dir=$(find ~/projects -maxdepth 2 -type d -name "$name" 2>/dev/null | head -1)
    if [ -n "$dir" ]; then
        cd "$dir" && make workspace
    else
        echo "Proyecto '$1' no encontrado"
    fi
}
```

De ahí salen dos restricciones duras:

| Restricción | Consecuencia |
|---|---|
| `find ~/projects -maxdepth 2` | El proyecto debe vivir en `~/projects/<grupo>/<nombre>` o `~/projects/<nombre>`. Más profundo y `work` no lo encuentra. |
| `make workspace` | Sin objetivo `workspace` en el `Makefile`, `work` falla aunque encuentre el directorio. |

---

## Los dos artefactos por proyecto

1. `dev.kdl` en la raíz del proyecto (el layout de zellij).
2. Objetivos `workspace` y `kill` en el `Makefile`.

El **nombre de sesión de zellij es el nombre del proyecto**, siempre.

### Plantilla: `Makefile`

```makefile
PROJECT := mi-proyecto

.PHONY: workspace kill

workspace: ## Abre el workspace de zellij (esto es lo que corre `work mi-proyecto`)
	@command -v zellij >/dev/null || { \
		echo "zellij no está instalado: cargo install --locked zellij"; \
		exit 1; \
	}
	@echo "Starting dev workspace..."
	@zellij kill-session $(PROJECT) 2>/dev/null || true
	@zellij delete-session $(PROJECT) 2>/dev/null || true
	@zellij --session $(PROJECT) --new-session-with-layout $(CURDIR)/dev.kdl

kill: ## Cierra el workspace
	@echo "Killing workspace..."
	@zellij kill-session $(PROJECT) 2>/dev/null || echo "No active session '$(PROJECT)' to kill."
```

`kill-session` + `delete-session` antes de abrir es obligatorio: si no, zellij
resucita la sesión vieja con el layout viejo y los cambios al `dev.kdl` no se ven.

Usa `$(CURDIR)/dev.kdl` (ruta absoluta). La forma relativa `dev.kdl` funciona
solo porque `work` hace `cd` antes; la absoluta funciona siempre.

### Plantilla: `dev.kdl`

```kdl
layout {
    cwd "/root/projects/<grupo>/<nombre>"

    tab name="code" focus=true {
        pane split_direction="vertical" {
            pane name="editor" size="60%" command="hx" {
                args "."
            }
            pane name="git" size="40%" command="lazygit"
        }
    }

    tab name="claude" {
        pane name="claude"
    }

    tab name="servers" {
        pane name="dev" command="make" {
            args "dev"
        }
    }

    tab name="terminal" {
        pane name="terminal"
    }
}
```

El `cwd` de arriba es **absoluto**; los `cwd` de los paneles internos son
**relativos** a ese.

Si el proyecto no trae su propio layout, se usa el global
`~/.config/zellij/layouts/dev.kdl` (code + claude + terminal, sin servidores).

---

## Anatomía del layout

| Elemento | Regla | Ejemplo real |
|---|---|---|
| `cwd` de arriba | Absoluto, raíz del proyecto | todos |
| Pestaña `code` | `focus=true`, `hx .` al 60% + `lazygit` al 40% | todos |
| `lazygit` en monorepo | **Un panel por sub-repo**, apilados horizontalmente dentro del 40% | cuarzosmx (2), insytech-vision (4) |
| Pestaña `claude` | Un panel vacío, sin comando | todos |
| Pestaña de servidores | Un panel por proceso, cada uno arrancando un objetivo del `Makefile` | cuarzosmx, insytech-vision, vanerp, insytech-crm |
| Rejilla de servidores | 4 procesos → 2×2: `vertical` con dos `horizontal` anidados | insytech-vision |
| Pestaña de base de datos | Opcional: logs del contenedor + panel libre para `psql`/`sqlx` | insytech-crm |
| Pestaña `terminal` | Opcional, uno o dos paneles vacíos | vanerp, insytech-crm |
| Nombre del archivo | `dev.kdl`. **Excepción**: vanerp usa `dev-layout.kdl` | — |

### lazygit por sub-repo (monorepo)

```kdl
pane split_direction="horizontal" size="40%" {
    pane name="git-backend" command="lazygit" {
        cwd "cuarzosmx"
    }
    pane name="git-storefront" command="lazygit" {
        cwd "cuarzosmx-storefront"
    }
}
```

### Rejilla 2×2 de servidores

```kdl
tab name="servers" {
    pane split_direction="vertical" {
        pane split_direction="horizontal" {
            pane name="client" command="make" { args "client" }
            pane name="server" command="make" { args "server" }
        }
        pane split_direction="horizontal" {
            pane name="storage" command="make" { args "storage" }
            pane name="training" command="make" { args "training" }
        }
    }
}
```

---

## `close_on_exit=false`

Por defecto zellij cierra el panel cuando el proceso termina. Con
`close_on_exit=false` el panel **sobrevive al fallo con la salida a la vista** y
se relanza con ENTER. Es lo que quieres en compilaciones y servidores que se
caen: el error se queda en pantalla en vez de desaparecer con el panel.

```kdl
pane name="leptos" command="make" close_on_exit=false {
    args "work"
}
```

Solo lo usan **vanerp** e **insytech-crm** (y el layout global). cuarzosmx e
insytech-vision no lo tienen: ahí un proceso caído se lleva el panel. Ponlo en
proyectos nuevos, sobre todo en paneles de build/servidor.

---

## Dependencias antes de zellij

Si el proyecto necesita servicios de fondo (Postgres, Redis), arráncalos en el
propio objetivo `workspace`, **antes** de abrir zellij, no dentro de un panel:
así todos los paneles nacen con las dependencias listas.

```makefile
workspace:
	@echo "Starting dev database..."
	@$(DOCKER_COMPOSE) up -d postgres redis
	@zellij kill-session $(PROJECT) 2>/dev/null || true
	@zellij delete-session $(PROJECT) 2>/dev/null || true
	@zellij --session $(PROJECT) --new-session-with-layout $(CURDIR)/dev-layout.kdl
```

Conviene cuando **más de un panel** depende del servicio, o cuando el arranque
tarda (esperar el healthcheck) y no quieres que los paneles fallen en carrera.
Si solo un panel lo usa, basta con encadenarlo en su objetivo
(insytech-crm: `work: db migrate` y el panel corre `make work`).

---

## Alias corto

Si el nombre del proyecto es largo, agrégalo al `case` de la función en
`~/.bashrc`:

```bash
    crm) name="insytech-crm" ;;
    depot|vandepot) name="van-depot" ;;
```

**Esto edita el `~/.bashrc` del usuario**: avísale antes de tocarlo, y recuérdale
que el alias no existe hasta que abra una terminal nueva o haga `source ~/.bashrc`.
Sin alias, `work <nombre-completo>` funciona igual.

---

## Verificar un layout nuevo sin secuestrar la terminal

`zellij` exige una pty y se adueña de la terminal. **Nunca** corras
`make workspace` directo: el agente se queda colgado. Envuélvelo en `script`,
en segundo plano, y consulta el estado por fuera.

```bash
# 1. Arrancar la sesión con una pty falsa, en segundo plano
script -qec "zellij --session probe --new-session-with-layout /ruta/al/dev.kdl" /dev/null &
sleep 3

# 2. ¿Arrancó?
zellij list-sessions

# 3. ¿Salieron las pestañas esperadas?
zellij --session probe action query-tab-names

# 4. Limpiar SIEMPRE
zellij kill-session probe
zellij delete-session probe
```

Si `list-sessions` no muestra la sesión, el KDL tiene un error de sintaxis: córrelo
en primer plano un segundo para leer el mensaje, o revisa `zellij setup --check`.

---

## Checklist para agregar un proyecto

- [ ] El proyecto está en `~/projects/<grupo>/<nombre>` (máximo 2 niveles).
- [ ] `dev.kdl` en la raíz, con `cwd` absoluto.
- [ ] Pestañas: `code` (hx 60% + lazygit 40%, uno por sub-repo), `claude`, servidores.
- [ ] `close_on_exit=false` en los paneles de build/servidor.
- [ ] Objetivo `workspace` en el `Makefile`, con `kill-session` + `delete-session` antes.
- [ ] Objetivo `kill` en el `Makefile`.
- [ ] Nombre de sesión = nombre del proyecto.
- [ ] Dependencias (Docker) arrancadas en `workspace` si más de un panel las necesita.
- [ ] Alias en el `case` de `~/.bashrc` si el nombre es largo (avisar al usuario).
- [ ] Layout verificado con `script` + `list-sessions` + `query-tab-names`, y sesión de prueba borrada.
- [ ] **No** se creó ningún ejecutable llamado `work`.

---

## Commands

```bash
work <proyecto>                    # Abre el workspace (función de bash, no script)
make workspace                     # Lo mismo, desde dentro del proyecto
make kill                          # Cierra la sesión de zellij
zellij list-sessions               # Sesiones vivas
zellij --session X action query-tab-names   # Pestañas de una sesión
zellij kill-session X && zellij delete-session X   # Limpieza
```

## Resources

- Función `work`: `~/.bashrc`
- Layout global de respaldo: `~/.config/zellij/layouts/dev.kdl`
- Ejemplos: `~/projects/insytech/cuarzosmx` (monorepo 2 repos),
  `~/projects/insytech/insytech-vision` (monorepo 4 repos, rejilla 2×2),
  `~/projects/vandev/vanerp` (`dev-layout.kdl`, Docker antes de zellij),
  `~/projects/insytech/insytech-crm` (repo único, pestaña de base de datos)
