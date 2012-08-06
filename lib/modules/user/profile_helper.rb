class User
  module ProfileHelper
    def test
      self.profile 
    end

    def name
      self.profile.first_name + " " + self.profile.last_name
    end

    def exp
      self.profile.exp
    end

    def reputation
      self.profile.reputation
    end

    def rank
      User.joins(:profile).where("profiles.gp > (?)", self.exp).count + 1
    end

    def gp
      self.profile.gp
    end

    def level
      self.profile.level
    end
  end
end
