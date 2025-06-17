<script setup>
import createCom from '@/components/commande/createCom.vue';
import detailCom from '@/components/commande/detailCom.vue';
import UpdateCom from '@/components/commande/updateCom.vue';
import { ref,onMounted,computed } from 'vue';
  
// État des modals
const showAjout = ref(false)
const showModifier = ref(false)
const shawDetail=ref(false)

// Fonctions modals
const openAjoutModal = () => {
  showAjout.value = true
}

const closeAjoutModal = () => {
  showAjout.value = false
}
//Ouvrir la page de modification avec les elements a modifier
const comAEditer = ref(null)
/* function openModifier(commande) {
  comAEditer.value = commande
  showModifier.value = true
} */

const closeModifierModal = () => {
  showModifier.value = false
  //codefour.value = null
}
//ouvrir le detail
const commandeSelectionnee = ref(null)
function openDetail(commande) {
  commandeSelectionnee.value = commande
  shawDetail.value = true
}

const closeDetail = () => {
  shawDetail.value = false
  //codefour.value = null
}
const commande=ref([])
//afficher les commandes
onMounted(async () => {
  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/commande/readcom.php?host=localhost&dbname=licence2025&username=root&password=')
    if (!res.ok) throw new Error("Erreur serveur")
    commande.value = await res.json()
  } catch (err) {
    error.value = "Impossible de charger les commandes"
    console.error(err)
  }
})
async function openModifier(commande) {
  try {
    const res = await fetch(`http://localhost/apiLicence2025/controller/commande/readLigneCom.php?host=localhost&dbname=licence2025&username=root&password=`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ idcom: commande.idcom })  // Assure-toi que "commande.idcom" existe
    });

    if (!res.ok) throw new Error("Erreur HTTP: " + res.status);

    const lignes = await res.json();

    comAEditer.value = {
      ...commande,
      lignes: lignes.map(l => ({
        articleId: parseInt(l.idArt),
        desArt: l.desArt,
        quantite: parseFloat(l.qteC),
        prixUnitaire: parseFloat(l.puC),
        uniteId: l.intituleU,
        idu:parseInt(l.idU)
      }))
    };

    showModifier.value = true;
  } catch (error) {
    console.error("Erreur chargement lignes commande :", error);
    alert("Impossible de charger les lignes de la commande.");
  }
}

async function deletecom(numcom) {
  if (!confirm("Confirmer la suppression de cette commande?")) return;
  try {
    const res = await fetch(`http://localhost/apiLicence2025/controller/commande/supprimerVirtuellement.php?host=localhost&dbname=licence2025&username=root&password=`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ numcom })
    });
    const result = await res.json();
    if (result.success) {
      commande.value = commande.value.filter(c => c.numcom !== numcom);
      alert(result.message);
    } else {
      alert(result.message);
    }
  } catch (err) {
    console.error(err);
    alert("Erreur de suppression.");
  }
}
// Filtrage des magasins selon le champ de recherche
const recherche = ref('')
const comFiltres = computed(() => {
  const texte = recherche.value.toLowerCase().trim()
  if (!texte) return commande.value
  return commande.value.filter(commande =>
    commande.numcom.toLowerCase().includes(texte) ||
    commande.refcom.toLowerCase().includes(texte)
  )
})

const imprimerCommande = (commande) => {
  // Exemple simple : ouvrir une nouvelle fenêtre avec les détails de la commande
  const contenu = `
    <html>
      <head>
        <title>Commande ${commande.numcom}</title>
        <style>
          body { font-family: Arial; padding: 20px; }
          h2 { color: rgb(104, 128, 251); }
        </style>
      </head>
      <body>
        <h2>Commande n° ${commande.numcom}</h2>
        <p><strong>Date :</strong> ${commande.datecom}</p>
        <p><strong>Fournisseur :</strong> ${commande.nomfour}</p>
        <p><strong>Montant total :</strong> ${commande.montantTcom} FCFA</p>
        <!-- Tu peux ajouter plus de champs ici -->
      </body>
    </html>
  `
  const fenetre = window.open('', '_blank')
  fenetre.document.write(contenu)
  fenetre.document.close()
  fenetre.print()
}

  </script>

<template>
    <div class="container-fluid py-3">
      <!-- Titre et bouton Actualiser -->
      <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap">
        <h4 class="text-primary">Gestion des achats</h4>
        <router-link to="/acceuil">  <button class="btn btn-danger">
        <i class="bi bi-box-arrow-left me-1"></i> Quitter
      </button>
    </router-link>
      </div>
  
      <!-- Boutons et recherche -->
      <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-2">
        <div class="btn-group">
          <button class="btn btn-primary btn-sm" @click="openAjoutModal">Nouveau</button>
        </div>
        <div class="input-group" style="max-width: 200px;">
          <input v-model="recherche" type="text" class="form-control form-control-sm" placeholder="Rechercher...">
          <button class="btn btn-outline-secondary btn-sm"><i class="bi bi-search"></i></button>
        </div>
      </div>
  
      <!-- Tableau -->
      <div class="table-responsive">
        <table class="table table-hover table-bordered align-middle">
          <thead class="table-primary text-center">
            <tr>
              <th>Num Commande</th>
              <th>Nom Fournisseur</th>
              <th style="min-width: 100px;">Référence</th>
              <th>Date</th>
               <th>Montant total(FCFA)</th>
                <th>Magasins de stock</th> 
              <th style="min-width: 130px;">Action</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(commande, index) in comFiltres" :key="index">
              <td>{{ commande.numcom }}</td>
              <td>{{ commande.nomfour }}</td>
              <td>{{ commande.refcom }}</td>
              <td>{{ commande.datecom }}</td>
              <td>{{ commande.montantTcom }}</td>
              <td>{{ commande.nomMag }}</td> 
              <td class="text-center">
                <button @click="openModifier(commande)" class="btn btn-sm text-warning border-0 me-1" title="Modifier">
                  <i class="bi bi-pencil-square"></i>
                </button>
                <button @click="openDetail(commande)" class="btn btn-sm text-primary border-0 me-1" title="Détails">
                  <i class="bi bi-eye"></i>
                </button>
                <button @click="deletecom(commande.numcom)" class="btn btn-sm text-danger border-0" title="Supprimer">
                  <i class="bi bi-trash"></i>
                </button>
                <button @click="imprimerCommande(commande)" class="btn btn-sm text-success border-0 me-1" title="Imprimer">
                  <i class="bi bi-printer"></i>
                </button>

              </td>
            </tr>
             <tr v-if="comFiltres.length === 0">
              <td colspan="3" class="text-center text-muted">Aucune commande trouvée</td>
            </tr>
          </tbody>
        </table>
      </div>
        <!-- total ligne -->
         <div class="text-muted justify-content-right mt-3">Total commande : {{ comFiltres.length  }}</div>
      <!-- imprimer -->
      
    </div>

    <!-- Modal d’AJOUT -->
  <div v-if="showAjout" class="modal-backdrop fade show"></div>
  <div v-if="showAjout" class="modal fade show d-block" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header bg-primary text-white">
          <h5 class="modal-title">Ajouter un achat</h5>
          <button class="btn-close" @click="closeAjoutModal" aria-label="Fermer"></button>
        </div>
        <div class="modal-body">
          <createCom @close="closeAjoutModal" />
        </div>
      </div>
    </div>
  </div>
 <!-- Modal de detail -->
 <div v-if="shawDetail" class="modal-backdrop fade show"></div>
  <div v-if="shawDetail" class="modal fade show d-block" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header bg-primary text-white">
          <h5 class="modal-title">Detail de la commande</h5>
          <button class="btn-close" @click="closeDetail" aria-label="Fermer"></button>
        </div>
        <div class="modal-body">
          <detailCom v-if="shawDetail"
            :numcom="commandeSelectionnee?.numcom" @fermer="closeDetail" />
        </div>
      </div>
    </div>
  </div>
 <!-- Modal de MODIFICATION -->
  <div v-if="showModifier" class="modal-backdrop fade show"></div>
  <div v-if="showModifier" class="modal fade show d-block" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header bg-primary text-white">
          <h5 class="modal-title">Modifier une commande</h5>
          <button class="btn-close" @click="closeModifierModal" aria-label="Fermer"></button>
        </div>
        <div class="modal-body">
          <UpdateCom :comAEditer="comAEditer" @close="closeModifierModal" />
        </div>
      </div>
    </div>
  </div>
  </template>
  
  <style scoped>
  @media (max-width: 768px) {
    .table th, .table td {
      font-size: 0.85rem;
    }
  }
  </style>
  