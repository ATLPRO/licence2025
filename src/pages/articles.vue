<script setup>
import { ref, computed,onMounted } from 'vue'
import createArticle from '@/components/articles/createArticle.vue'
import updateArticle from '@/components/articles/updateArticle.vue'
import familleArticle from '@/components/articles/familleArticle.vue'
import uniteArticle from '@/components/articles/uniteArticle.vue'
//import FamilleArticle from '@/components/articles/familleArticle.vue'

//gerer les ouvertures et fermeture des modal avec vuejs
const showAjout = ref(false)
const showModifier = ref(false)
const showFamille=ref(false)
const showUnite=ref(false)
//ouvrir nouveaue 
const openAjoutModal = () => {
  showAjout.value = true
}
//fermer nouveau 
const closeAjoutModal = () => {
  showAjout.value = false
}
//Ouvrir la page de modification avec les elements a modifier
const articleAEditer = ref(null)
function openModifierModal(article) {
  articleAEditer.value = article
  showModifier.value = true
}
//
const closeModifierModal=()=>{
  showModifier.value=false
}
//ouvrir famille
const openFamille = () => {
  showFamille.value = true
}
//fermer famille
const closeFamille = () => {
  showFamille.value = false
}
//ouvrir unite
const openUnite  = () => {
  showUnite.value = true
}
//fermer
const closeUnite = () => {
  showUnite.value = false
}
const error = ref('')
const article=ref([])
//afficher les articles
onMounted(async () => {
  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/article/readarticle.php?host=localhost&dbname=licence2025&username=root&password=')
    if (!res.ok) throw new Error("Erreur serveur")
    article.value = await res.json()
  } catch (err) {
    error.value = "Impossible de charger les articles"
    console.error(err)
  }
})
  //supprimer larticle
async function deleteArt(refArt) {
  if (!confirm("Confirmer la suppression de l'article?",article.refArt)) return;
  try {
    const res = await fetch(`http://localhost/apiLicence2025/controller/article/supprimerVirtuellement.php?host=localhost&dbname=licence2025&username=root&password=`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ refArt })
    });
    const result = await res.json();
    if (result.success) {
      article.value = article.value.filter(f => f.refArt !== refArt);
      alert(result.message);
    } else {
      alert(result.message);
    }
  } catch (err) {
    console.error(err);
    alert("Erreur de suppression.");
  }
}

// Filtrage des articles selon le champ de recherche
const recherche = ref('')
const articlesFiltres = computed(() => {
  const texte = recherche.value.toLowerCase().trim()
  if (!texte) return article.value
  return article.value.filter(article =>
    article.desArt.toLowerCase().includes(texte) ||
    article.refArt.toLowerCase().includes(texte)
  )
})


//const totalArticles = computed(() => article.value.length)
</script>

<template>
  <div class="container-fluid py-0">
    <!-- Titre et bouton au-dessus -->
    <div class="d-flex justify-content-between align-items-center mb-3">
      <h4 class="text-primary">Gestion des articles</h4>
    <router-link to="/acceuil">  <button class="btn btn-danger">
        <i class="bi bi-box-arrow-left me-1"></i> Quitter
      </button>
    </router-link>
    </div>

    <!-- Barre de recherche et boutons -->
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-3 gap-5">
        <div class="btn-group autres ">
        <button class="btn " @click="openAjoutModal">Nouveau</button>
        <button class="btn "  @click="openFamille">Famille</button>
        <button class="btn " @click="openUnite">Unité</button>
        <button class="btn ">Détail</button>
        <button class="btn ">Nommer</button>
      </div>
      <div  class="input-group" style="max-width: 200px;">
        <input v-model="recherche" type="text" class="form-control form-control-sm" placeholder="Rechercher un artic...">
        <button class="btn btn-outline-secondary btn-sm"><i class="bi bi-search"></i></button>
      </div>
    </div>

    <!-- Tableau des articles -->
    <div v-if="error" class="alert alert-danger">{{ error }}</div>
    <div class="table-responsive">
      <table class="table table-bordered table-hover table-striped align-middle">
        <thead class="table-primary">
          <tr>
            <th style="min-width: 130px;" class="text-center">Action</th>
            <th>Référence</th>
            <th>Désignation</th>
            <th>Qté Unitaire</th>
            <th>Grammage</th>
            <th>Prix d'achat(FCFA)</th>
            <th>Prix de vente(FCFA)</th>
            <th>Type</th>
            <th>Famille</th>
            <th>Stock initial</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(article, index) in articlesFiltres" :key="index">
            <td class="text-center">
              <button @click="openAjoutModal" class="btn btn-sm text-success border-0 me-1" title="Nouveau">
                  <i class="bi bi-plus-circle"></i>
                </button>
                <button @click="openModifierModal(article)" class="btn btn-sm text-warning border-0 me-1" title="Modifier">
                  <i class="bi bi-pencil-square"></i>
                </button>
                <button @click="deleteArt(article.refArt)" class="btn btn-sm text-danger border-0" title="Supprimer">
                  <i class="bi bi-trash"></i>
                </button>
              </td>

            <td>{{ article.refArt }}</td>
            <td>{{ article.desArt }}</td>
            <td>{{ article.QteUArt }}</td>
            <td>{{ article.grammage }}</td>
            <td>{{ article.pA }} </td>
            <td>{{ article.PV }} </td>
            <td>{{ article.typeArt }}</td>
            <td>{{ article.intituleFam }}</td>
            <td>{{ article.stockMin}}</td>
          </tr>
          <tr v-if="articlesFiltres.length === 0">
          <td colspan="3" class="text-center text-muted">Aucun article trouvé</td>
        </tr>
        </tbody>
      </table>
    </div>

    <!-- Total  -->
    
      <div class="text-muted justify-content-right mt-3">Total d’articles : {{ articlesFiltres.length  }}</div>
  </div>

  <!-- Modal d’AJOUT -->
  <div v-if="showAjout" class="modal-backdrop fade show"></div>
  <div v-if="showAjout" class="modal fade show d-block" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header bg-primary text-white">
          <h5 class="modal-title">Ajouter un Article</h5>
          <button class="btn-close" @click="closeAjoutModal" aria-label="Fermer"></button>
        </div>
        <div class="modal-body">
          <createArticle @close="closeAjoutModal" />
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
          <h5 class="modal-title">Modifier un Article</h5>
          <button class="btn-close" @click="closeModifierModal" aria-label="Fermer"></button>
        </div>
        <div class="modal-body">
          <updateArticle :article="articleAEditer" @close="closeModifierModal" />
        </div>
      </div>
    </div>
  </div>
 <!-- Modal de famille -->
 <div v-if="showFamille" class="modal-backdrop fade show"></div>
  <div v-if="showFamille" class="modal fade show d-block" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header bg-primary text-white">
          <h5 class="modal-title">Gerer les familles</h5>
          <button class="btn-close" @click="closeFamille" aria-label="Fermer"></button>
        </div>
        <div class="modal-body">
          <familleArticle @close="closeFamille" />
        </div>
      </div>
    </div>
  </div>

  <!-- Modal de l'unite -->
  <div v-if="showUnite" class="modal-backdrop fade show"></div>
  <div v-if="showUnite" class="modal fade show d-block" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header bg-primary text-white">
          <h5 class="modal-title">Gerer les unites</h5>
          <button class="btn-close" @click="closeUnite" aria-label="Fermer"></button>
        </div>
        <div class="modal-body">
          <uniteArticle  @close="closeUnite" />
        </div>
      </div>
    </div>
  </div>
</template>
<style scoped>

.form-control{
    width: 100px;
}
thead,tbody{
    font-size: 12px;
}
@media (max-width: 768px) {
  .table th, .table td {
    font-size: 0.85rem;
  }
}
</style>