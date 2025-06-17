<script setup>
import { ref, computed,onMounted } from 'vue'
import fonction from '@/components/personnel/fonction.vue';
import service from '@/components/personnel/service.vue';
import createpers from '@/components/personnel/createpers.vue';
import updatepers from '@/components/personnel/updatepers.vue';
import UpdateFour from '@/components/fournisseur/updateFour.vue';

//gerer les ouvertures et fermeture des modal avec vuejs
const showAjout = ref(false)
const showModifier = ref(false)
const showFonction=ref(false)
const showService=ref(false)
//ouvrir nouveaue 
const openAjoutModal = () => {
  showAjout.value = true
}
//fermer nouveau 
const closeAjoutModal = () => {
  showAjout.value = false
}
//Ouvrir la page de modification avec les elements a modifier
const personnelAEditer = ref(null)
function openModifierModal(personnel) {
  personnelAEditer.value = personnel
  showModifier.value = true
}
//
const closeModifierModal=()=>{
  showModifier.value=false
}
//ouvrir fonction
const openfonction = () => {
  showFonction.value = true
}
//fermer fonction 
const closefonction = () => {
  showFonction.value = false
}
//ouvrir unite
const openservice  = () => {
  showService.value = true
}
//fermer
const closeService = () => {
  showService.value = false
}
const error = ref('')
const personnel=ref([])
  //afficher les personnel
onMounted(async () => {
  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/personnel/readpers.php?host=localhost&dbname=licence2025&username=root&password=')
    if (!res.ok) throw new Error("Erreur serveur")
    personnel.value = await res.json()
  } catch (err) {
    error.value = "Impossible de charger les personnel"
    console.error(err)
  }
})
//supprimer le personnel
async function deletepers(matriculePers) {
  if (!confirm("Confirmer la suppression du personnel?")) return;
  try {
    const res = await fetch(`http://localhost/apiLicence2025/controller/personnel/supprimerVirtuellement.php?host=localhost&dbname=licence2025&username=root&password=`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ matriculePers })
    });
    const result = await res.json();
    console.log("code",result)
    if (result.success) {
      personnel.value = personnel.value.filter(p => p.matriculePers !== matriculePers);
      alert(result.message);
    } else {
      alert(result.message);
    }
  } catch (err) {
    console.error(err);
    alert("Erreur de suppression.");
  }
}

  </script>

<template>
    <div class="container-fluid py-3">
      <!-- Titre et bouton Actualiser -->
      <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap">
        <h4 class="text-primary">Gestion du personnel</h4>
        <!-- Quitter -->
        <router-link to="/acceuil">  <button class="btn btn-danger">
        <i class="bi bi-box-arrow-left me-1"></i> Quitter
      </button>
    </router-link>
      </div>
  
      <!-- Boutons et recherche -->
      <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-2">
        <div class="btn-group">
          <button @click="openAjoutModal" class="btn btn-primary btn-sm">Nouveau</button>
          <button @click="openfonction" class="btn btn-primary btn-sm">Fonction</button>
          <button @click="openservice" class="btn btn-primary btn-sm">Service</button>
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
              <th>Matricule</th>
              <th style="min-width: 100px;">Nom</th>
              <th>Prénom</th>
              <th style="min-width: 100px;">Poste</th>
              <th style="min-width: 100px;">Service</th>
              <th style="min-width: 100px;">Téléphone</th>
              <th >Sexe</th>
               <th style="min-width: 100px;">Date de naissance</th> 
              <th style="min-width: 100px;">Lieu</th>
              <th>Numero de CNI</th>
              <th style="min-width: 100px;">Date de validité</th>
              <th>Statut</th>
              <th style="min-width: 130px;">Action</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(personnel, index) in personnel" :key="index">
              <td>{{ personnel.matriculePers }}</td>
              <td>{{ personnel.nompers }}</td>
              <td>{{ personnel.prenompers }}</td>
              <td>{{ personnel.intituleFonc }}</td>
              <td>{{ personnel.intituleServ }}</td>
              <td>{{ personnel.numtelpers }}</td>
              <td>{{ personnel.sexepers }}</td>
              <td>{{ personnel.datenaispers }} </td>
              <td>{{ personnel.lieunaispers }}</td>
              <td>{{ personnel.numcnipers }}</td>
              <td>{{ personnel.datevalidite }}</td>
              <td>{{ personnel.statutpers }} </td>
              <td class="text-center">
                <button @click="openModifierModal(personnel)" class="btn btn-sm text-warning border-0 me-1" title="Modifier">
                  <i class="bi bi-pencil-square"></i>
                </button>
             <router-link to="/inscription" class="btn btn-sm btn-outline-warning me-1 d-inline-flex align-items-center" title="S’inscrire en tant qu'utilisateur">
                <i class="bi bi-person-plus-fill me-1"></i> 
              </router-link>

                <button @click="deletepers(personnel.matriculePers)" class="btn btn-sm text-danger border-0" title="Supprimer">
                  <i class="bi bi-trash"></i>
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
          <h5 class="modal-title">Ajouter un personnel</h5>
          <button class="btn-close" @click="closeAjoutModal" aria-label="Fermer"></button>
        </div>
        <div class="modal-body">
          <createpers @close="closeAjoutModal" />
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
          <h5 class="modal-title">Modifier un personnel</h5>
          <button class="btn-close" @click="closeModifierModal" aria-label="Fermer"></button>
        </div>
        <div class="modal-body">
          <updatepers :personnel="personnelAEditer" @close="closeModifierModal" />
        </div>
      </div>
    </div>
  </div>
  <!-- Modal de Fonction -->
 <div v-if="showFonction" class="modal-backdrop fade show"></div>
  <div v-if="showFonction" class="modal fade show d-block" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header bg-primary text-white">
          <h5 class="modal-title"></h5>
          <button class="btn-close" @click="closefonction" aria-label="Fermer"></button>
        </div>
        <div class="modal-body">
          <fonction @close="closeFonction" />
        </div>
      </div>
    </div>
  </div>
  <!-- Modal de service -->
  <div v-if="showService" class="modal-backdrop fade show"></div>
  <div v-if="showService" class="modal fade show d-block" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header bg-primary text-white">
          <h5 class="modal-title">Gerer les Services</h5>
          <button class="btn-close" @click="closeService" aria-label="Fermer"></button>
        </div>
        <div class="modal-body">
          <service  @close="closeService" />
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
  