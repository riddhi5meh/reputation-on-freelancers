module MyModule::FreelancerReputation {
    use aptos_framework::signer;

    /// Struct representing a freelancer's reputation profile
    struct ReputationProfile has store, key {
        total_rating: u64,      // Sum of all ratings received
        total_reviews: u64,     // Number of reviews received
        completed_projects: u64, // Number of completed projects
    }

    /// Function to create a new freelancer reputation profile
    public fun create_freelancer_profile(freelancer: &signer) {
        let profile = ReputationProfile {
            total_rating: 0,
            total_reviews: 0,
            completed_projects: 0,
        };
        move_to(freelancer, profile);
    }

    /// Function for clients to submit rating and mark project as completed
    public fun submit_rating_and_complete_project(
        client: &signer, 
        freelancer_address: address, 
        rating: u64
    ) acquires ReputationProfile {
        // Ensure rating is between 1 and 5
        assert!(rating >= 1 && rating <= 5, 1);
        
        let profile = borrow_global_mut<ReputationProfile>(freelancer_address);
        
        // Update reputation metrics
        profile.total_rating = profile.total_rating + rating;
        profile.total_reviews = profile.total_reviews + 1;
        profile.completed_projects = profile.completed_projects + 1;
    }

    /// Public view function to calculate average rating (for reference)
    #[view]
    public fun get_average_rating(freelancer_address: address): u64 acquires ReputationProfile {
        let profile = borrow_global<ReputationProfile>(freelancer_address);
        if (profile.total_reviews == 0) {
            return 0
        };
        profile.total_rating / profile.total_reviews
    }

    /// Public view function to get total completed projects (for reference)
    #[view] 
    public fun get_completed_projects(freelancer_address: address): u64 acquires ReputationProfile {
        let profile = borrow_global<ReputationProfile>(freelancer_address);
        profile.completed_projects
    }
}