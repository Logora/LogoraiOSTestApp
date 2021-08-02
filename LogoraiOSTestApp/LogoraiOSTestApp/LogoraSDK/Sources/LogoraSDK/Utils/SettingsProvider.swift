import Foundation

class SettingsProvider {
    static let sharedInstance = SettingsProvider()
    let apiClient = APIClient.sharedInstance
    var textPrimary: String = "#222222"
    var textSecondary: String = "#777777"
    var textTertiary: String = "#fafafa"
    var forPrimary: String = "#cc6a6d"
    var againstPrimary: String = "#7980bb"
    var callPrimary: String = "#434343"
    var providerToken: String? = "" {
        didSet {
            tokenUpdateCallback?(providerToken)
        }
    }
    private var value: [String: Any]?
    var theme: [String: String] = [:]
    var layout: [String: String] = [:]
    var tokenUpdateCallback: ((String?) -> Void)?
    
    private init() {
        print("INIT SETTINGS PROVIDER")
    }
    
    func getSettings(completion: (() -> Void)?) -> () {
        apiClient.getSettings { settings in
            self.value = settings
            self.providerToken = self.get(key: "provider_token")
            self.theme["defaultIconColor"] = "#777"
            self.theme["borderBoxColor"] = "#072a44"
            DispatchQueue.main.async {
                completion!()
            }
        }
    }
    
    func getTheme(key: String) -> String {
        return self.theme[key] ?? ""
    }
    
    func getString(key: String) -> String {
        return self.layout[key]!
    }
    
    func get(key: String) -> String {
        let keys = key.components(separatedBy: ".")
        if(self.value == nil) { return "" }
        var currentValue = self.value!
        for (index, key) in keys.enumerated() {
            if(currentValue[key] == nil) { return "" }
            if(index == keys.count - 1) {
                return currentValue[key] as! String
            } else {
                currentValue = currentValue[key] as! [String : Any]
            }
        }
        return ""
    }
    
    /*
    func setLocales(locales: Layout) {
        self.layout["infoAllDebates"] = locales.infoAllDebates ?? "Débats"
        self.layout["actionReadMore"] = locales.actionReadMore ?? "Lire plus"
        self.layout["actionSeeMore"] = locales.actionSeeMore ?? "Voir plus"
        self.layout["actionAddArgument"] = locales.actionAddArgument ?? "Ajouter un argument"
        self.layout["actionLinkToDebate"] = locales.actionLinkToDebate ?? "Aller au débat"
        self.layout["actionUpdate"] = locales.actionUpdate ?? "Modifier"
        self.layout["actionDelete"] = locales.actionDelete ?? "Supprimer"
        self.layout["actionShowResults"] = locales.actionShowResults ?? "Voir les résultats"
        self.layout["actionShowArgument"] = locales.actionShowArgument ?? "Voir mon argument"
        self.layout["actionBackToSynthesis"] = locales.actionBackToSynthesis ?? "Voir l'article lié au débat"
        self.layout["actionAbout"] = locales.actionAbout ?? "Qui sommes-nous ?"
        self.layout["actionAccept"] = locales.actionAccept ?? "Accepter"
        self.layout["actionCancel"] = locales.actionCancel ?? "Annuler"
        self.layout["actionReply"] = locales.actionReply ?? "Répondre"
        self.layout["actionClose"] = locales.actionClose ?? "Fermer"
        self.layout["actionReport"] = locales.actionReport ?? "Signaler"
        self.layout["actionSubmit"] = locales.actionSubmit ?? "Envoyer"
        self.layout["actionSignup"] = locales.actionSignup ?? "Je m'inscris"
        self.layout["actionSigninIn"] = locales.actionSigninIn ?? "Connexion"
        self.layout["actionSigninMyself"] = locales.actionSigninMyself ?? "Je me connecte"
        self.layout["actionShare"] = locales.actionShare ?? "Partager"
        self.layout["actionAdd"] = locales.actionAdd ?? "Ajouter"
        self.layout["actionSearch"] = locales.actionSearch ?? "Rechercher"
        self.layout["actionSave"] = locales.actionSave ?? "Enregistrer"
        self.layout["actionFollowedDebate"] = locales.actionFollowedDebate ?? "Débat suivi"
        self.layout["actionFollow"] = locales.actionFollow ?? "Suivre"
        self.layout["actionFollowed"] = locales.actionFollowed ?? "Suivi"
        self.layout["actionCreateDebate"] = locales.actionCreateDebate ?? "Proposer un sujet"
        self.layout["actionLoginFollow"] = locales.actionLoginFollow ?? "Enregistrer votre action"
        self.layout["actionLoginReport"] = locales.actionLoginReport ?? "Enregistrer votre signalement"
        self.layout["actionLoginSave"] = locales.actionLoginSave ?? "Enregistrer votre "
        self.layout["actionLoginClose"] = locales.actionLoginClose ?? "Continuer sans enregistrer"
        self.layout["actionMoreReplies"] = locales.actionMoreReplies ?? "Voir plus de réponses"
        self.layout["actionSeeArguments"] = locales.actionSeeArguments ?? "Voir les arguments"
        self.layout["fallBackNoArguments"] = locales.fallBackNoArguments ?? "Pas d'arguments"
        self.layout["fallbackNoParticipants"] = locales.fallbackNoParticipants ?? "Aucun participants"
        self.layout["fallbackNotStarted"] = locales.fallbackNotStarted ?? "Le débat n'a pas encore commencé"
        self.layout["fallbackError"] = locales.fallbackError ?? "Une erreur est survenue lors de la récupération du débat"
        self.layout["fallbackNoSources"] = locales.fallbackNoSources ?? "Aucune source pour cet argument"
        self.layout["fallbackNoChallenges"] = locales.fallbackNoChallenges ?? "Aucun défi à relever pour le moment"
        self.layout["fallbackNoBadges"] = locales.fallbackNoBadges ?? "Aucun badge pour le moment"
        self.layout["fallbackNoNotifications"] = locales.fallbackNoNotifications ?? "Aucune notifiction pour le moment"
        self.layout["fallbackFailToLoadSource"] = locales.fallbackFailToLoadSource ?? "Impossible de retirer la source. Veuillez réessayer."
        self.layout["fallbackNoDescription"] = locales.fallbackNoDescription ?? "Pas de description pour l'instant"
        self.layout["fallbackIndex"] = locales.fallbackIndex ?? "Aucun débat n'a encore été créé. Cet espace affichera les débats tendances et les débatteurs de la semaine. Vous pouvez créer votre premier débat depuis votre espace d'administration Logora."
        self.layout["infoArgumentAdded"] = locales.infoArgumentAdded ?? "Votre argument à bien été ajouté"
        self.layout["infoRgpd"] = locales.infoRgpd ?? "En cliquant sur \"Accepter\", vous autorisez la réception de notifications par email, qui peuvent être désactivées depuis votre profil."
        self.layout["infoRgpdInfo"] = locales.infoRgpdInfo ?? "recevra les informations suivantes :"
        self.layout["infoRgpdList"] = locales.infoRgpdList ?? "Nom, Prénom, E-mail"
        self.layout["infoModerated"] = locales.infoModerated ?? "En attente de modération"
        self.layout["infoRejected"] = locales.infoRejected ?? "Rejeté"
        self.layout["infoWelcome"] = locales.infoWelcome ?? "Bienvenue"
        self.layout["infoLogin"] = locales.infoLogin ?? "sur l'espace de débat. Pour profiter des fonctionnalités, c'est par ici !"
        self.layout["infoSortByRelevance"] = locales.infoSortByRelevance ?? "Le plus pertinent"
        self.layout["infoSortByNewest"] = locales.infoSortByNewest ?? "Le plus récent"
        self.layout["infoSortByOldest"] = locales.infoSortByOldest ?? "Le plus ancien"
        self.layout["infoSortByTrendingDebate"] = locales.infoSortByTrendingDebate ?? "Débats tendances"
        self.layout["infoSortByOldestDebate"] = locales.infoSortByOldestDebate ?? "Débats les plus anciens"
        self.layout["infoSortByNewestDebate"] = locales.infoSortByNewestDebate ?? "Débats les plus récents"
        self.layout["infoParticipantsCount"] = locales.infoParticipantsCount ?? "Nombre de participants"
        self.layout["infoArgumentsCount"] = locales.infoArgumentsCount ?? "Nombre d'arguments"
        self.layout["infoAlreadySignedUp"] = locales.infoAlreadySignedUp ?? "Déjà un compte ?"
        self.layout["infoAnswerTo"] = locales.infoAnswerTo ?? "En réponse à"
        self.layout["infoRelatedDebates"] = locales.infoRelatedDebates ?? "Débats selectionnés pour vous"
        self.layout["infoMadeBy"] = locales.infoMadeBy ?? "Propulsé par"
        self.layout["infoLoading"] = locales.infoLoading ?? "Chargement..."
        self.layout["infoDebates"] = locales.infoDebates ?? "Débats"
        self.layout["infoDebaters"] = locales.infoDebaters ?? "Débatteurs"
        self.layout["infoCopyToClipboard"] = locales.infoCopyToClipboard ?? "Copier le lien"
        self.layout["infoLinkCopied"] = locales.infoLinkCopied ?? "Lien copié"
        self.layout["infoFbShare"] = locales.infoFbShare ?? "Partager sur Facebook"
        self.layout["infoTwitterShare"] = locales.infoTwitterShare ?? "Partager sur Twitter"
        self.layout["infoMailShare"] = locales.infoMailShare ?? "Partager par mail"
        self.layout["infoChooseSide"] = locales.infoChooseSide ?? "Choisissez votre camp"
        self.layout["infoSourceUrl"] = locales.infoSourceUrl ?? "URL de la source"
        self.layout["infoSources"] = locales.infoSources ?? "Sources"
        self.layout["infoDeleteArgument"] = locales.infoDeleteArgument ?? "Supprimer mon argument"
        self.layout["infoConfirmDeleteArgument"] = locales.infoConfirmDeleteArgument ?? "Êtes-vous sûr de vouloir supprimer cet argument ?"
        self.layout["infoAddSource"] = locales.infoAddSource ?? "Ajouter une source"
        self.layout["infoAllDebatesShort"] = locales.infoAllDebatesShort ?? "Débats"
        self.layout["infoSearchMobile"] = locales.infoSearchMobile ?? "Recherche..."
        self.layout["infoSeeMoreDebates"] = locales.infoSeeMoreDebates ?? "Voir plus de débats"
        self.layout["infoWithFb"] = locales.infoWithFb ?? "avec Facebook"
        self.layout["infoSocialLogin"] = locales.infoSocialLogin ?? "Créez votre compte en un clic pour voter et participer au débat."
        self.layout["infoLoginMail"] = locales.infoLoginMail ?? "J'accepte de recevoir les notifications par mail"
        self.layout["infoReadMoreLink"] = locales.infoReadMoreLink ?? "Lire plus"
        self.layout["infoModeration"] = locales.infoModeration ?? "En attente de modération"
        self.layout["infoDebateIsInactive"] = locales.infoDebateIsInactive ?? "Le débat est suspendu pour le moment."
        self.layout["infoReplyIsInactive"] = locales.infoReplyIsInactive ?? "Le débat est clos."
        self.layout["infoAlreadyAccount"] = locales.infoAlreadyAccount ?? "Déjà un compte ?"
        self.layout["infoNoAccount"] = locales.infoNoAccount ?? "Pas encore de compte ?"
        self.layout["headerBestUsers"] = locales.headerBestUsers ?? "Débatteurs de la semaine"
        self.layout["headerUserArguments"] = locales.headerUserArguments ?? "L'historique des contributions dans les débats, pratique !"
        self.layout["headerMainDebate"] = locales.headerMainDebate ?? "Débat à l'affiche"
        self.layout["headerTrendingDebate"] = locales.headerTrendingDebate ?? "Débats tendances"
        self.layout["headerBestArguments"] = locales.headerBestArguments ?? "Meilleurs arguments"
        self.layout["headerArgumentsSubtitle"] = locales.headerArgumentsSubtitle ?? "Vos arguments"
        self.layout["headerVoteConfirmModal"] = locales.headerVoteConfirmModal ?? "Votre vote a bien été pris en compte !"
        self.layout["headerArgumentInput"] = locales.headerArgumentInput ?? "Ajoutez un argument travaillé pour soutenir votre position"
        self.layout["headerArgumentListTitle"] = locales.headerArgumentListTitle ?? "Soyez le premier à donner votre avis !"
        self.layout["headerBadgesBoxTitle"] = locales.headerBadgesBoxTitle ?? "Salle des badges"
        self.layout["headerNextBadgesBoxTitle"] = locales.headerNextBadgesBoxTitle ?? "Prochains badges à obtenir"
        self.layout["headerTellUsMore"] = locales.headerTellUsMore ?? "Dîtes nous-en plus"
        self.layout["headerDebateTitle"] = locales.headerDebateTitle ?? "L'espace de débat"
        self.layout["headerDebateContext"] = locales.headerDebateContext ?? "Proposer un sujet à la rédaction"
        self.layout["headerNotifications"] = locales.headerNotifications ?? "Notifications"
        self.layout["headerUserBadges"] = locales.headerUserBadges ?? "Les actions sont récompensées par l'obtention de badges. Attrapez-les tous !"
        self.layout["headerUserDisciples"] = locales.headerUserDisciples ?? "Les disciples sont les débatteurs qui vous suivent. Avoir des disciples est une force et une responsabilité, soyez à la hauteur !"
        self.layout["headerUserMentors"] = locales.headerUserMentors ?? "Les mentors sont les débatteurs que vous suivez. Ils éclairent votre réflexion et orientent vos débats."
        self.layout["headerUserDebates"] = locales.headerUserDebates ?? "L'historique des débats suivis et des débats en cours. Pratique !"
        self.layout["headerUserReport"] = locales.headerUserReport ?? "Récapitulatif mensuel d'activité"
        self.layout["headerUserActivity"] = locales.headerUserActivity ?? "Réponse dans un de vos débats"
        self.layout["headerUserFollowed"] = locales.headerUserFollowed ?? "Activité de vos mentors"
        self.layout["headerUserGroupFollowed"] = locales.headerUserGroupFollowed ?? "Activité des débats suivis"
        self.layout["headerUserNotifications"] = locales.headerUserNotifications ?? "Notifications par mail"
        self.layout["headerUserNewsletter"] = locales.headerUserNewsletter ?? "Débats de la semaine"
        self.layout["headerReport"] = locales.headerReport ?? "Signaler un argument"
        self.layout["headerReportSubtitle"] = locales.headerReportSubtitle ?? "Raison du signalement"
        self.layout["statsParticipants"] = locales.statsParticipants ?? "participant"
        self.layout["statsParticipantsPlural"] = locales.statsParticipantsPlural ?? "participants"
        self.layout["statsArguments"] = locales.statsArguments ?? "argument"
        self.layout["statsArgumentsPlural"] = locales.statsArgumentsPlural ?? "arguments"
        self.layout["statsVotes"] = locales.statsVotes ?? "vote"
        self.layout["statsVotesPlural"] = locales.statsVotesPlural ?? "votes"
        self.layout["notificationsNewBadge"] = locales.notificationsNewBadge ?? "Vous avez obtenu le badge"
        self.layout["notificationsLevelUp"] = locales.notificationsLevelUp ?? "Vous êtes maintenant au niveau"
        self.layout["notificationsMentorLevelUp"] = locales.notificationsMentorLevelUp ?? "a atteint le niveau"
        self.layout["notificationsFollowed"] = locales.notificationsFollowed ?? "vous a suivi"
        self.layout["notificationsMultipleAnswers"] = locales.notificationsMultipleAnswers ?? "autres personnes ont répondu"
        self.layout["notificationsAnswer"] = locales.notificationsAnswer ?? "a répondu"
        self.layout["notificationsMultipleSupport"] = locales.notificationsMultipleSupport ?? "autres personnes soutiennent"
        self.layout["notificationsSupport"] = locales.notificationsSupport ?? "soutient"
        self.layout["notificationsMultipleParticipations"] = locales.notificationsMultipleParticipations ?? "autres personnes ont participé"
        self.layout["notificationsParticipation"] = locales.notificationsParticipation ?? "a participé"
        self.layout["notificationsSubject"] = locales.notificationsSubject ?? "a votre message dans le débat"
        self.layout["notificationsSubjectArgument"] = locales.notificationsSubjectArgument ?? "votre argument"
        self.layout["notificationsSubjectDebate"] = locales.notificationsSubjectDebate ?? "dans le débat"
        self.layout["notificationsReadAll"] = locales.notificationsReadAll ?? "Tout marquer comme lu"
        self.layout["userMyDebates"] = locales.userMyDebates ?? "Mes débats"
        self.layout["userDebates"] = locales.userDebates ?? "Débats"
        self.layout["userMyBadges"] = locales.userMyBadges ?? "Mes badges"
        self.layout["userBadges"] = locales.userBadges ?? "Badges"
        self.layout["userMentors"] = locales.userMentors ?? "Mentors"
        self.layout["userMyMentors"] = locales.userMyMentors ?? "Mes mentors"
        self.layout["userDisciples"] = locales.userDisciples ?? "Disciples"
        self.layout["userMyDisciples"] = locales.userMyDisciples ?? "Mes disciples"
        self.layout["userUpdateProfile"] = locales.userUpdateProfile ?? "Modifier mon profil"
        self.layout["userEmptyTags"] = locales.userEmptyTags ?? "Pas assez d'activité"
        self.layout["userTagsHeader"] = locales.userTagsHeader ?? "Intérêts"
        self.layout["reportSpam"] = locales.reportSpam ?? "Spam"
        self.layout["reportHarassment"] = locales.reportHarassment ?? "Harcèlement"
        self.layout["reportHateSpeech"] = locales.reportHateSpeech ?? "Discours haineux"
        self.layout["reportPlagiarism"] = locales.reportPlagiarism ?? "Plagiat"
        self.layout["reportFakeNews"] = locales.reportFakeNews ?? "Fausses informations"
        self.layout["errorList"] = locales.errorList ?? "Une erreur est survenue lors de la récupération du contenu."
    }
    */
}
