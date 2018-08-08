import Foundation

class EventList : NSObject {
   
    @objc dynamic var id: Long
    @objc dynamic var name: String
    @objc dynamic var identifier: String
    @objc dynamic var startsAt: String
    @objc dynamic var endsAt: String
    @objc dynamic var timezone: String
    @objc dynamic var privacy: String = "public"
    @objc dynamic var paymentCountry: String? = nil
    @objc dynamic var paypalEmail: String? = nil
    @objc dynamic var thumbnailImageUrl: String? = nil
    @objc dynamic var schedulePublishedOn: String? = nil
    @objc dynamic var paymentCurrency: String? = nil
    @objc dynamic var organizerDescription: String? = nil
    @objc dynamic var originalImageUrl: String? = nil
    @objc dynamic var onsiteDetails: String? = nil
    @objc dynamic var organizerName: String? = nil
    @objc dynamic var largeImageUrl: String? = nil
    @objc dynamic var deletedAt: String? = nil
    @objc dynamic var ticketUrl: String? = nil
    @objc dynamic var locationName: String? = nil
    @objc dynamic var codeOfConduct: String? = nil
    @objc dynamic var state: String? = nil
    @objc dynamic var searchableLocationName: String? = nil
    @objc dynamic var description: String? = nil
    @objc dynamic var pentabarfUrl: String? = nil
    @objc dynamic var xcalUrl: String? = nil
    @objc dynamic var logoUrl: String? = nil
    @objc dynamic var externalEventUrl: String? = nil
    @objc dynamic var iconImageUrl: String? = nil
    @objc dynamic var icalUrl: String? = nil
    @objc dynamic var createdAt: String? = nil
    @objc dynamic var bankDetails: String? = nil
    @objc dynamic var chequeDetails: String? = nil
    @objc dynamic var isComplete: Boolean = false
    @objc dynamic var latitude: Double? = nil
    @objc dynamic var longitude: Double? = nil
    
    @objc dynamic var canPayByStripe: Boolean = false
    @objc dynamic var canPayByCheque: Boolean = false
    @objc dynamic var canPayByBank: Boolean = false
    @objc dynamic var canPayByPaypal: Boolean = false
    @objc dynamic var canPayOnsite: Boolean = false
    @objc dynamic var isSponsorsEnabled: Boolean = false
    @objc dynamic var hasOrganizerInfo: Boolean = false
    @objc dynamic var isSessionsSpeakersEnabled: Boolean = false
    @objc dynamic var isTicketingEnabled: Boolean = false
    @objc dynamic var isTaxEnabled: Boolean = false
    @objc dynamic var isMapShown: Boolean = false
    @objc dynamic var favorite: Boolean = false
    @objc dynamic var eventTopic: EventTopic? = nil
}
