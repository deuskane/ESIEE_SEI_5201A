#===================================================================
# Variables
#===================================================================
# Configuration
DRAWIO_APP     = drawio
SCALE          = 2
FORMAT         = png

# 1. Lister tous les fichiers source
SOURCES        = $(wildcard *.drawio)

# 2. Fonction pour extraire les noms d'onglets et préparer les chemins d'images
# On crée une liste de type : exports_nom/onglet1.png exports_nom/onglet2.png
IMAGE_TARGETS := $(shell \
	for f in $(SOURCES); do \
		base=$$(basename $$f .drawio); \
		$(DRAWIO_APP) --uncompressed -x -o "$$f.xml" "$$f" > /dev/null 2>&1; \
		grep -o 'name="[^"]*"' "$$f.xml" | sed 's/name="//;s/"//' | \
		while read name; do \
			echo "exports_$${base}/$${base}-$${name}.$(FORMAT)"; \
		done; \
		rm -f "$$f.xml"; \
	done \
)

#===================================================================
# Target
#===================================================================

#-------------------------------------------------------------------
all: $(IMAGE_TARGETS)
#-------------------------------------------------------------------
	@echo "$(IMAGE_TARGETS)"
	@echo "--- Toutes les images sont à jour ---"

.PHONY: all

# Règle magique pour générer CHAQUE image individuellement
# Elle extrait l'index de page à la volée pour l'export
#-------------------------------------------------------------------
exports_%/ :
#-------------------------------------------------------------------
	@mkdir -p "$@"

#-------------------------------------------------------------------
exports_$(basename $(notdir %))/%.$(FORMAT): %.drawio
#-------------------------------------------------------------------
	@# (Cette règle est gérée par la règle statique ci-dessous pour plus de fiabilité)

# Génération dynamique des règles pour chaque image
define GEN_RULE
# 1 : source file
# 2 : dest file
# 3 : page indexe

$(2): $(1) | $$(dir $(2))
	@\
	$(DRAWIO_APP) --export --format $(FORMAT) --transparent --scale $(SCALE) --page-index $(3) --crop --output "$(2)" "$(1)"
endef

# On applique la règle à chaque cible
$(foreach idx,$(shell seq 1 $(words $(IMAGE_TARGETS))),$(eval $(call GEN_RULE,$(firstword $(foreach src,$(SOURCES),$(if $(findstring exports_$(basename $(src)),$(word $(idx),$(IMAGE_TARGETS))),$(src)))),$(word $(idx),$(IMAGE_TARGETS)),$(idx))))

#-------------------------------------------------------------------
clean:
#-------------------------------------------------------------------
	rm -rf exports_*

.PHONY: clean
