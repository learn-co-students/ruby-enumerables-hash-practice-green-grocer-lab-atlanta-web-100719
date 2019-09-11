def consolidate_cart(cart)
  cart.reduce({}) do |memo, item| 
    item.each do |key,value| 
      value[:count]=cart.count(item)
      memo[key]=value 
    end  
    memo 
  end
end

def apply_coupons(cart, coupons)
  new_cart = cart
  coupons.each do |coupon|
    if (new_cart[coupon[:item]] != nil) && (new_cart[coupon[:item]][:count] >= coupon[:num])
      new_cart[coupon[:item]][:count] -= coupon[:num] 
      if new_cart[coupon[:item] + " W/COUPON"] == nil
        new_cart[coupon[:item] + " W/COUPON"] = {
          :price => coupon[:cost] / coupon[:num], 
          :clearance => new_cart[coupon[:item]][:clearance],
          :count => coupon[:num]
        }
      else
        new_cart[coupon[:item] + " W/COUPON"][:count] += coupon[:num]
      end
    end 
  end
  new_cart
end

def apply_clearance(cart)
  cart.each do |key, value|
    if value[:clearance]
      value[:price] = (value[:price] * 0.80).round(2)
    end
  end
end

def checkout(cart, coupons)
  cc = consolidate_cart(cart)
  cp = apply_coupons(cc, coupons)
  cl = apply_clearance(cp)
  
  grand_total = cl.reduce(0) {|sum, (key, value)| sum += (value[:price] * value[:count]).round(2) }
  
  grand_total > 100 ? (grand_total * 0.90).round(2) : grand_total
end

def consolidate_cart2(cart)
  new_hash = Hash.new
  cart.uniq.each do |item| 
    item.each do |key, value|
      value [:count] = cart.count(item)
      new_hash [key] = value
    end 
  end 
  new_hash
end