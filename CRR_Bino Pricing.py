###### Derivatives Assignment 2 #####
# Author: Jeremy Tan, CID: 01237350, Imperial College London
# This assignment is to create a function for n-period 
# recombining binomial tree function to calculate the option prices of
# both European and American style options

### INPUT PARAMETERS
# StockPrice = Current Stock Price
# StrikePrice = Strike Price of the Option
# Rf = Risk-free rate quoted at per annum
# Vol = Volatility of the Stock's return quoted at per annum
# Maturity = Time till expiry in years
# nPeriods = number of periods of the binomial tree
# PutorCall = Put or Call option
# Type = European or American style option

import numpy as np
import math as m
import matplotlib.pyplot as plt

def nBinoTree(StockPrice, StrikePrice, Rf, Vol, Maturity, nPeriods, PutorCall, Type):

	# Initialising input parameters
	dt = Maturity/nPeriods
	u = m.exp(Vol * m.sqrt(dt))
	d = 1/u
	q = (m.exp(Rf*dt) - d) / (u - d)
	df = m.exp(-(Rf*dt))

	# Initialising necessary ingredient matrices
	Prices = np.zeros((nPeriods + 1, nPeriods + 1))
	Prices[0,0] = 1
	StatePrices = np.zeros((nPeriods + 1, nPeriods + 1))
	OptionPrices = np.zeros((nPeriods + 1, nPeriods + 1))
	V = np.zeros((nPeriods + 1, 1))
	tracksp = np.zeros((nPeriods + 1, nPeriods +1))

	# print(Prices)
	
	# Creating Stock Price Recombining Binomial Tree
	for i in range(nPeriods+1):
		if i == 0:
			for j in range(i+1,nPeriods+1):
				Prices[i,j] = u ** j
		else:
			for j in range(i,nPeriods+1):
				Prices[i,j] = (d ** i) * (u ** (j-i))

	Prices = StockPrice * Prices
	# print(Prices)

	# Creating State Price Matrix
	for i in range(nPeriods+1):
		if i == nPeriods:
			StatePrices[i,i] = 0
		else:
			StatePrices[np.ix_([i],[i,i+1])] = [q, 1-q]

	StatePrices = df * StatePrices
	
	# print(StatePrices)

	# Terminal Payoff Vector
	if PutorCall == 'Call':
		V = np.maximum((Prices[:,-1] - StrikePrice), V.T)
	elif PutorCall == 'Put':
		V = np.maximum((StrikePrice - Prices[:,-1]), V.T)
	else:
		raise ValueError('Please enter "Put" or "Call"')

	# print(V.T)
		
	# Creating Option Matrix and computing Option Price
	if Type == 'European':
		for i in reversed(range(nPeriods)):
			OptionPrices = StatePrices.dot(V.T)
			V = OptionPrices.T
	elif Type == 'American':
		Prices[Prices==0] = StrikePrice
		for i in reversed(range(nPeriods)):
			OptionPrices = StatePrices.dot(V.T)
			if PutorCall == 'Call':
				V = np.maximum((Prices[:,i-(nPeriods+1)] - StrikePrice), OptionPrices.T)
			elif PutorCall == 'Put':
				V = np.maximum((StrikePrice - Prices[:,i-(nPeriods+1)]), OptionPrices.T)
	else: 
		raise ValueError('Please enter "American" or "European"')

	# print(OptionPrices)
	
	# Creating Free Boundary for American option
	if (Type == 'American' and PutorCall == 'Put'):
		for i in range(nPeriods+1):
			for j in range(nPeriods+1):
				if StrikePrice - Prices[i,j] > 0:
					tracksp[i,j] = 1
	elif (Type == 'American' and PutorCall == 'Call'):
		for i in range(nPeriods+1):
			for j in range(nPeriods+1):
				if Prices[i,j] - StrikePrice > 0:
					tracksp[i,j] = 1
	
	# print(tracksp)
	
	fb = tracksp * Prices
	fbsp = fb.max(0)
	x = np.arange(nPeriods+1)
	print(fb)
	
	plt.plot(x, fbsp)
	plt.title('Free Boundary')
	plt.show()
	
	print('The price of the ', Type, PutorCall,'is', OptionPrices[0,0])

	return;


# Testing CRR Binomial Tree function
# 1a) European call with 2 periods
nBinoTree(40, 40, 0.04, 0.3, 0.5, 2, 'Call', 'European')
# 1b) with 10 periods
nBinoTree(40, 40, 0.04, 0.3, 0.5, 10, 'Call', 'European')
# 1c) with 100 periods
nBinoTree(40, 40, 0.04, 0.3, 0.5, 100, 'Call', 'European')
# 1d) American call with 10 periods
nBinoTree(40, 40, 0.04, 0.3, 0.5, 10, 'Call', 'American')
# 1e) American put with 50 periods
nBinoTree(40, 40, 0.04, 0.3, 0.5, 50, 'Put', 'American')
# 1f) Most accurate price for American put 
nBinoTree(40, 40, 0.04, 0.3, 0.5, 10000, 'Put', 'American')

# 2a) Graph of free boundary for American Put
nBinoTree(100, 100, 0.05, 0.3, 1, 800, 'Put', 'American')







