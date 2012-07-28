class BadgeManager < ActiveRecord::Base
  attr_accessible :correct_qiar_counter, :cr_q_counter, :cr_qiar_counter, :math_q_counter, :math_qiar_counter, :perfect_replay_counter, :question_counter, :user_id, :wr_q_counter, :wr_qiar_counter

class << self

  def awardBadges(user,question,choice)
    user_entry=BadgeManager.find_or_create_by_user_id(user.id)

    # Increment/Reset counters
    if choice.correct?
      increment_q_counter(user_entry,question)
    else
      reset_qiar_counter(user_entry,question)
    end
    
    # Save
    user_entry.save!

    # Consider badges
    consider_badges(user_entry)
  end

  def awardReplayBadge(user,question,counter)
    
  end

  def increment_q_counter(user_entry,question)
    user_entry.question_counter+=1
    user_entry.correct_qiar_counter+=1
    
    if question.question_type.cr?
      user_entry.cr_q_counter+=1
      user_entry.cr_qiar_counter+=1
    elsif question.question_type.wr?
      user_entry.wr_q_counter+=1
      user_entry.wr_qiar_counter+=1
    elsif question.question_type.math?
      user_entry.math_q_counter+=1
      user_entry.math_qiar_counter+=1
    end
  end

  def reset_qiar_counter(user_entry,question)
    user_entry.correct_qiar_counter=0
    
    if question.question_type.cr?
      user_entry.cr_qiar_counter=0
    elsif question.question_type.wr?
      user_entry.wr_qiar_counter=0
    elsif question.question_type.math?
      user_entry.math_qiar_counter=0
    end
  end

  def consider_badges(user_entry)
    consider_undefeated_badges(user_entry)
    consider_scholar_badges(user_entry)
    consider_mathematician_badges(user_entry)
    consider_pen_badges(user_entry)
    consider_reader_badges(user_entry)
  end

  def consider_undefeated_badges(user_entry)
    if user_entry.correct_qiar_counter==10
      user.badges << Badge.find_by_name!("10-undefeated")
    elsif user_entry.correct_qiar_counter==50
      user.badges << Badge.find_by_name!("50-undefeated")
    elsif user_entry.correct_qiar_counter==100
      user.badges << Badge.find_by_name!("100-undefeated")
    end
  end

  def consider_altruist_badges(user_entry)
    
  end

  def consider_scholar_badges(user_entry)
    if user_entry.question_counter==100
      user.badges << Badge.find_by_name!("Scholar Lv1")
    elsif user_entry.question_counter==1000
      user.badges << Badge.find_by_name!("Scholar Lv2")
    elsif user_entry.question_counter==5000
      user.badges << Badge.find_by_name!("Scholar Lv3")
    elsif user_entry.question_counter==10000
      user.badges << Badge.find_by_name!("Legendary Scholar")
    end
  end

  def consider_reviewer_badges(user_entry)

  end

  def consider_mathematician_badges(user_entry)
    if user_entry.math_q_counter==50 and user_entry.math_qiar_counter==5
      user.badges << Badge.find_by_name!("Mathematician Lv1")
    elsif user_entry.math_q_counter==100 and user_entry.math_qiar_counter==20
      user.badges << Badge.find_by_name!("Mathematician Lv2")
    elsif user_entry.math_q_counter==1000 and user_entry.math_qiar_counter==50
      user.badges << Badge.find_by_name!("Legendary Mathematician")
    end
  end

  def consider_pen_badges(user_entry)
    if user_entry.wr_q_counter==50
      user.badges << Badge.find_by_name!("Wood Brush")
    elsif user_entry.wr_q_counter==100 and user_entry.math_qiar_counter==10
      user.badges << Badge.find_by_name!("Gem Pen")
    elsif user_entry.wr_q_counter==200 and user_entry.math_qiar_counter==20
      user.badges << Badge.find_by_name!("Silver Pen")
    elsif user_entry.wr_q_counter==300 and user_entry.math_qiar_counter==30
      user.badges << Badge.find_by_name!("Golden Pen")
    elsif user_entry.wr_q_counter==400 and user_entry.math_qiar_counter==40
      user.badges << Badge.find_by_name!("Platinum Pen")
    elsif user_entry.wr_q_counter==1000 and user_entry.math_qiar_counter==100
      user.badges << Badge.find_by_name!("Legendary Writer")
    end
  end

  def consider_reader_badges(user_entry)
    if user_entry.cr_q_counter==50 and user_entry.cr_qiar_counter==5
      user.badges << Badge.find_by_name!("Avid Reader Lv1")
    elsif user_entry.cr_q_counter==100 and user_entry.cr_qiar_counter==20
      user.badges << Badge.find_by_name!("Avid Reader Lv2")
    elsif user_entry.cr_q_counter==500 and user_entry.cr_qiar_counter==30
      user.badges << Badge.find_by_name!("Avid Reader Lv3")
    elsif user_entry.cr_q_counter==1000 and user_entry.cr_qiar_counter==50
      user.badges << Badge.find_by_name!("Bookworm")
    end
  end
end
