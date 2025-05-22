<script setup>
import { ref, computed } from 'vue'
import createArticle from '@/components/articles/createArticle.vue'
import updateArticle from '@/components/articles/updateArticle.vue'
import familleArticle from '@/components/articles/familleArticle.vue'
import uniteArticle from '@/components/articles/uniteArticle.vue'

const search = ref('')
const articles = ref([
  {
    reference: 'A001',
    designation: 'Article 1',
    quantiteUnitaire: 10,
    grammage: '250g',
    prixAchat: 1000,
    prixVente: 1500,
    type: 'Produit fini',
    famille: 'Agro',
    stockInitial: 50,
  },
  {
    reference: 'A002',
    designation: 'Article 2',
    quantiteUnitaire: 5,
    grammage: '500g',
    prixAchat: 2000,
    prixVente: 3000,
    type: 'Matière première',
    famille: 'Boissons',
    stockInitial: 20,
  },
])

const filteredArticles = computed(() => {
  if (!search.value) return articles.value
  return articles.value.filter(article =>
    Object.values(article).some(val =>
      String(val).toLowerCase().includes(search.value.toLowerCase())
    )
  )
})


const totalArticles = computed(() => articles.value.length)
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
        <button class="btn " data-bs-toggle="modal" data-bs-target="#modalFamille">Famille</button>
        <button class="btn " data-bs-toggle="modal" data-bs-target="#modalUnite">Unité</button>
        <button class="btn ">Détail</button>
        <button class="btn ">Nommer</button>
      </div>
      <div class="input-group" style="max-width: 200px;">
        <input type="text" class="form-control form-control-sm" placeholder="Rechercher un artic...">
        <button class="btn btn-outline-secondary btn-sm"><i class="bi bi-search"></i></button>
      </div>
    </div>

    <!-- Tableau des articles -->
    <div class="table-responsive">
      <table class="table table-bordered table-hover table-striped align-middle">
        <thead class="table-primary">
          <tr>
            <th style="min-width: 130px;" class="text-center">Action</th>
            <th>Référence</th>
            <th>Désignation</th>
            <th>Qté Unitaire</th>
            <th>Grammage</th>
            <th>Prix d'achat</th>
            <th>Prix de vente</th>
            <th>Type</th>
            <th>Famille</th>
            <th>Stock initial</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(article, index) in filteredArticles" :key="index">
            <td class="text-center">
                <i class="bi bi-plus-circle text-success border-0 me-3" role="button" title="Nouveau"
                data-bs-toggle="modal" data-bs-target="#modalAjout"></i>
               
<i class="bi bi-pencil-square text-warning border-0 me-3" role="button" title="Modifier"
data-bs-toggle="modal" data-bs-target="#modalModifier">
</i>
                <i class="bi bi-trash text-danger border-0 me-3" role="button" title="Supprimer"></i>
            </td>

            <td>{{ article.reference }}</td>
            <td>{{ article.designation }}</td>
            <td>{{ article.quantiteUnitaire }}</td>
            <td>{{ article.grammage }}</td>
            <td>{{ article.prixAchat }} FCFA</td>
            <td>{{ article.prixVente }} FCFA</td>
            <td>{{ article.type }}</td>
            <td>{{ article.famille }}</td>
            <td>{{ article.stockInitial }}</td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Total  -->
    
      <div class="text-muted justify-content-right mt-3">Total d’articles : {{ totalArticles }}</div>
     
  
  </div>

  <!-- Modal d’ajout -->
<div class="modal fade" id="modalAjout" tabindex="-1" aria-labelledby="modalAjoutLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header bg-primary text-white ">
        <h5 class="modal-title" id="modalAjoutLabel">Ajouter un article</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fermer"></button>
      </div>
      <div class="modal-body">
       <createArticle />
      </div>
    </div>
  </div>
</div>
<!-- Modal de modification -->
<div class="modal fade" id="modalModifier" tabindex="-1" aria-labelledby="modalAjoutLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header bg-primary text-white ">
        <h5 class="modal-title" id="modalAjoutLabel">Modifier un article</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fermer"></button>
      </div>
      <div class="modal-body">
       <updateArticle/>
      </div>
    </div>
  </div>
</div>
<!-- Modal de famille -->
<div class="modal fade" id="modalFamille" tabindex="-1" aria-labelledby="modalAjoutLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header bg-primary text-white ">
        <h5 class="modal-title" id="modalAjoutLabel">Famille d'articles</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fermer"></button>
      </div>
      <div class="modal-body">
       <familleArticle/>
      </div>
    </div>
  </div>
</div>
<!-- Modal de unite article -->
<div class="modal fade" id="modalUnite" tabindex="-1" aria-labelledby="modalAjoutLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header bg-primary text-white ">
        <h5 class="modal-title" id="modalAjoutLabel">Gestion des unités d'articles</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fermer"></button>
      </div>
      <div class="modal-body">
       <uniteArticle/>
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