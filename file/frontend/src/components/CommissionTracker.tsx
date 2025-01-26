import React, { useState, useEffect } from 'react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';

const CommissionTracker = () => {
  const [commissions, setCommissions] = useState({
    total: 0,
    rates: {}
  });

  const fetchCommissionData = async () => {
    try {
      // Placeholder for blockchain data fetching
      const mockData = {
        total: 1250,
        rates: {
          'payment': 5,
          'transfer': 3,
          'withdrawal': 2
        }
      };
      setCommissions(mockData);
    } catch (error) {
      console.error('Failed to fetch commission data');
    }
  };

  useEffect(() => {
    fetchCommissionData();
  }, []);

  return (
    <Card className="w-full max-w-md">
      <CardHeader>
        <CardTitle>Commission Tracker</CardTitle>
      </CardHeader>
      <CardContent>
        <div className="space-y-4">
          <div>
            <p className="text-sm font-medium">Total Commissions</p>
            <p className="text-2xl font-bold">${commissions.total.toFixed(2)}</p>
          </div>
          <div>
            <h3 className="text-md font-semibold mb-2">Commission Rates</h3>
            {Object.entries(commissions.rates).map(([type, rate]) => (
              <div key={type} className="flex justify-between">
                <span>{type.charAt(0).toUpperCase() + type.slice(1)}</span>
                <span>{rate}%</span>
              </div>
            ))}
          </div>
        </div>
      </CardContent>
    </Card>
  );
};

export default CommissionTracker;
