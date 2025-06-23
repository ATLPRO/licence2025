<script setup>
import createProd from '@/components/production/createProd.vue';
import detailprod from '@/components/production/detailprod.vue';
import {ref,onMounted} from 'vue'
// État des modals
const showAjout = ref(false)
const showModifier = ref(false)
const shawDetail=ref(false)
const productions=ref([])
// Fonctions modals
const openAjoutModal = () => {
  showAjout.value = true
}

const closeAjoutModal = () => {
  showAjout.value = false
}
//ouvrir le detail
const productionSelectionnee = ref(null)
function openDetail(pro) {
  productionSelectionnee.value = pro
  shawDetail.value = true
}

const closeDetail = () => {
  shawDetail.value = false
  //codefour.value = null
}
 onMounted(async () => {
  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/production/readpro.php?host=localhost&dbname=licence2025&username=root&password=')
    if (!res.ok) throw new Error("Erreur serveur")
    productions.value = await res.json()
  } catch (err) {
    error.value = "Impossible de charger les commandes"
    console.error(err)
  }
})

  const imprimerCommande = (pro) => {
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
        <p><strong>Fournisseur :</strong> ${commande.fournisseur}</p>
        <p><strong>Montant total :</strong> ${commande.montant} FCFA</p>
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
        <h4 class="text-primary">Gestion des productions</h4>
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
          <input type="text" class="form-control form-control-sm" placeholder="Rechercher...">
          <button class="btn btn-outline-secondary btn-sm"><i class="bi bi-search"></i></button>
        </div>
      </div>
  
      <!-- Tableau -->
      <div class="table-responsive">
        <table class="table table-hover table-bordered align-middle">
          <thead class="table-primary text-center">
            <tr>
              <th>Numéro</th>
              <th style="min-width: 130px;">Référence</th>
              <th style="min-width: 130px;">Date</th>
              <th style="min-width: 130px;">Coût Total</th>
              <th style="min-width: 130px;">Action</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(pro, index) in productions" :key="index">
              <td>{{ pro.numprod }}</td>
              <td>{{ pro.refprod }}</td>
              <td>{{ pro.dateprod }}</td>
              <td>{{ pro.coutTprod }} FCFA</td>
              <td class="text-center">
                <button class="btn btn-sm text-warning border-0 me-1" title="Modifier">
                  <i class="bi bi-pencil-square"></i>
                </button>
                <button @click="openDetail(pro)" class="btn btn-sm text-primary border-0 me-1" title="Détails">
                  <i class="bi bi-eye"></i>
                </button>
                <button class="btn btn-sm text-danger border-0" title="Supprimer">
                  <i class="bi bi-trash"></i>
                </button>
                <button @click="imprimerCommande(pro)" class="btn btn-sm text-success border-0 me-1" title="Imprimer">
                  <i class="bi bi-printer"></i>
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
  
      
    </div>
     <!-- Modal d’AJOUT -->
  <div v-if="showAjout" class="modal-backdrop fade show"></div>
  <div v-if="showAjout" class="modal fade show d-block" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header bg-primary text-white">
          <h5 class="modal-title">Creer et simuler une production</h5>
          <button class="btn-close" @click="closeAjoutModal" aria-label="Fermer"></button>
        </div>
        <div class="modal-body">
          <createProd @close="closeAjoutModal" />
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
          <h5 class="modal-title">Detail de la production</h5>
          <button class="btn-close" @click="closeDetail" aria-label="Fermer"></button>
        </div>
        <div class="modal-body">
          <detailprod v-if="shawDetail"
            :idprod="productionSelectionnee?.idprod" @fermer="closeDetail" />
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
  