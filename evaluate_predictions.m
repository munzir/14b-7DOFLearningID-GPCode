function pct = evaluate_predictions(predictions, test_torque)
    
    diff = minus(predictions, test_torque);

    for i = 1:7
        rmse(i) = norm(diff(:,i));
        test_torque(i) = norm(test_torque(:,i));
        pct(i) = rmse(i)/test_torque(i);
    end
