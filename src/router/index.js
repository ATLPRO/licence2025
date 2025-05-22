// router/index.js
import { createRouter, createWebHistory } from 'vue-router'

import Connexion from '@/pages/connexion.vue'
import Inscription from '@/pages/inscription.vue'
import Reinitialiser from '@/pages/reinitialiser.vue'

import Acceuil from '@/pages/acceuil.vue'
import Articles from '@/pages/articles.vue'
import Magasin from '@/pages/magasins.vue'
import Fournisseurs from '@/pages/fournisseurs.vue'
import Commande from '@/pages/commandes.vue'
import Production from '@/pages/production.vue'
import Personnel from '@/pages/personnels.vue'

const routes = [
  { path: '/', redirect: '/connexion' },
  { path: '/connexion', component: Connexion },
  { path: '/inscription', component: Inscription },
  { path: '/reinitialiser', component: Reinitialiser },

  { path: '/acceuil', component: Acceuil },
  { path: '/articles', component: Articles },
  { path: '/magasin', component: Magasin },
  { path: '/fournisseurs', component: Fournisseurs },
  { path: '/commande', component: Commande },
  { path: '/production', component: Production },
  { path: '/personnel', component: Personnel },
  { path: '/createArticle', component: () => import('@/components/articles/createArticle.vue'), name: 'createArticle' },
  { path: '/createMagasin', component: () => import('@/components/magasin/createMagasin.vue'), name: 'createMagasin' }
  
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

router.beforeEach((to, from, next) => {
  const publicPages = ['/connexion', '/inscription', '/reinitialiser']
  const isAuth = localStorage.getItem('auth') === 'true'

  if (!publicPages.includes(to.path) && !isAuth) {
    return next('/connexion')
  }

  if (to.path === '/connexion' && isAuth) {
    return next('/acceuil')
  }

  next()
})

export default router
