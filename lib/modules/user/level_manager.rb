class User
  module LevelManager
    WIN_GP = 10
    LOSE_GP = 2
    def self.threshold_for(level)
      (level+3)**3
    end

    def self.level_for(gp)
      output = (gp**(1/3.0)).to_i - 3
      output > 0 ? output : 1
    end

    def update_level(win)
      #self.profile.increment!(:gp, win ? WIN_GP : LOSE_GP)
      profile = self.profile
      profile.gp += WIN_GP
      profile.save
      new_level = LevelManager.level_for(self.gp)
      level_changed = new_level != self.level

      self.profile.update_attribute(:level, new_level) if level_changed
      return level_changed
    end

    def expected(question)
      toReturn = {}
      if question.exp
        toReturn[:user] = 1/(1+10**((question.exp-self.exp)/400.0))
        toReturn[:question] = 1/(1+10**((self.exp-question.exp)/400.0))
      end
      return toReturn
    end

    def lose_to!(question)
      expectation = expected(question)
      change = (32*expectation[:user]).to_i
      profile=self.profile
      profile.decrement!(:exp, change)
      question.increment!(:exp, change)
      update_level(false)
      profile.save!
      return change
    end

    def win_to!(question)
      expectation = expected(question)
      change = (32*expectation[:question]).to_i
      profile=self.profile
      profile.increment!(:exp, change)
      question.decrement!(:exp, change)
      update_level(true)
      profile.save!
      return change
    end
  end
end
