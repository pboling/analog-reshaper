# Mix Analog::Reshaper into analog gem, which utilizes the Scale namespace:
Scale::Scheme.send(:prepend, Analog::Reshaper)
